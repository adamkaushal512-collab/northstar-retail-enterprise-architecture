# NorthStar Retail — DynamoDB Data Model

**Phase:** 7 — Data Architecture & Event-Driven Systems
**Status:** Proposed design — not implemented

## 1. Purpose

Define the proposed DynamoDB data model for inventory
availability, reservations, idempotency, and outbox records.

The design prioritizes correctness, predictable access
patterns, scalability, and reliable event publication.

## 2. Database Selection

Amazon DynamoDB is proposed for the Inventory Reservation
Service because it supports:

- Low-latency key-based operations
- Conditional writes
- ACID transactions
- Managed scaling
- High availability
- Integration with AWS event-processing services

DynamoDB does not eliminate hot-key contention or remove
the need for careful application-level consistency design.

## 3. Proposed Table Design

For the initial design, use four logical tables:

1. Inventory
2. Reservations
3. Idempotency
4. Outbox

Physical consolidation into fewer tables may be evaluated
after access patterns and performance are validated.

## 4. Inventory Table

Primary key:

- Partition key: storeId
- Sort key: sku

Example:

{
  "storeId": "STORE101",
  "sku": "LAPTOP001",
  "available": 25,
  "reserved": 5,
  "version": 12
}

Access patterns:

- Get inventory for one store and SKU
- Query inventory items belonging to a store
- Atomically reserve available inventory
- Release previously reserved inventory

A conditional update must require sufficient available
quantity before decrementing inventory.

## 5. Reservations Table

Primary key:

- Partition key: reservationId

Example:

{
  "reservationId": "RES500",
  "orderId": "ORD900",
  "storeId": "STORE101",
  "sku": "LAPTOP001",
  "quantity": 2,
  "status": "ACTIVE"
}

Proposed GSI:

- Partition key: orderId
- Sort key: reservationId

This supports retrieving reservations associated with an order.

GSI reads are eventually consistent and must not be used
as the sole authority for correctness-critical decisions.

## 6. Idempotency Table

Primary key:

- Partition key: idempotencyKey

Example:

{
  "idempotencyKey": "REQ1001",
  "requestHash": "example-hash",
  "reservationId": "RES500",
  "status": "COMPLETED"
}

Requirements:

- The same logical request reuses the same key.
- Replays return the existing committed result.
- Reusing a key with different request content is rejected.
- Idempotency records are coordinated atomically with
  the corresponding reservation transaction.
- Record retention must exceed the supported retry window.

Request hashes must be computed using a documented,
stable canonicalization process.

## 7. Outbox Table

Primary key:

- Partition key: eventId

Example:

{
  "eventId": "EVT1001",
  "eventType": "InventoryReserved",
  "reservationId": "RES500",
  "publicationStatus": "PENDING"
}

The outbox stores durable publication intent.

A publisher sends committed events to EventBridge.

The publisher must support retry, recovery, monitoring,
and duplicate-safe publication behavior.

A separate index or access mechanism is required to
efficiently discover pending records.

## 8. Atomic Reservation Transaction

Use DynamoDB TransactWriteItems to coordinate:

1. Conditional inventory decrement
2. Reservation record creation
3. Idempotency record creation
4. Outbox record creation

All operations must succeed or fail together.

The transaction must enforce uniqueness and inventory
constraints using appropriate conditional expressions.

Publishing to EventBridge occurs after the transaction
and is not part of DynamoDB's ACID boundary.

## 9. Concurrent Reservation Handling

Scenario:

- Available inventory: 1
- Customer A requests 1
- Customer B requests 1

The inventory conditional update permits only one
transaction to commit successfully.

The other transaction receives a conflict or failure
that the application maps to the appropriate API response.

## 10. Scaling and Hot-Key Risks

High demand for a single SKU at one store can create
write contention on the same inventory record.

Mitigations to evaluate:

- Capacity and throttling monitoring
- Bounded retries with jitter
- Application-level admission control
- Load testing for popular SKUs
- Safe partitioning or sharding strategies

Sharding must not compromise the authoritative inventory
invariant or permit overselling.

## 11. Consistency

Correctness-critical operations use conditional writes
or transactions.

Strongly consistent reads are supported on base tables
and local secondary indexes.

Global secondary indexes are eventually consistent.

Replicated analytical and inventory views are not
authoritative for reservation decisions.

## 12. Recovery and Operations

Operational requirements include:

- Transaction failure monitoring
- Idempotent API retries
- Outbox publication recovery
- DynamoDB capacity and latency metrics
- Point-in-time recovery evaluation
- Backup and restore testing
- Access controls and encryption

## 13. Open Questions

- Final table consolidation strategy
- Reservation lifecycle and cancellation model
- Inventory versioning strategy
- Hot-key throughput targets
- Idempotency retention period
- Outbox pending-record access pattern
- TTL and archival policies
- Cross-region recovery requirements
- Transaction size and throughput validation

## 14. Related Documents

- data-architecture.md
- event-data-contracts.md
- ../../diagrams/data-architecture.mmd

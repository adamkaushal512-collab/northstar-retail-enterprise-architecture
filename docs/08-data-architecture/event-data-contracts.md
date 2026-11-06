# NorthStar Retail — Event Data Contracts

**Phase:** 7 — Data Architecture & Event-Driven Systems
**Status:** Proposed design — not implemented

## 1. Purpose

Define the event data contracts and processing rules used
to synchronize NorthStar Retail systems reliably.

The architecture uses Amazon EventBridge and independent
Amazon SQS consumer queues.

## 2. Event Architecture

The proposed event flow is:

Inventory Reservation Service
    -> Durable Outbox
    -> Outbox Publisher
    -> Amazon EventBridge
    -> Consumer SQS Queues
    -> Downstream Services

Consumers include:

- Online Inventory View
- Store Fulfillment
- Analytics Ingestion

The architecture must tolerate duplicate delivery,
out-of-order events, consumer failures, and delayed processing.

## 3. Domain Events

| Event | Meaning | Producer |
|---|---|---|
| OrderPlaced | Customer order accepted | OMS |
| InventoryReserved | Inventory reservation committed | Reservation Service |
| InventoryReservationReleased | Reservation released | Reservation Service |
| PaymentCaptured | Payment successfully captured | Payments |
| OrderShipped | Order shipped | Fulfillment |

These are proposed domain events. Ownership and publication
contracts require review by the relevant service teams.

## 4. InventoryReserved Contract

The existing Phase 6 schema is:

../07-integration-design/inventory-reserved-event.schema.json

Example event:

{
  "eventId": "EVT1001",
  "eventType": "InventoryReserved",
  "eventVersion": "1.0",
  "occurredAt": "2026-11-05T14:30:00Z",
  "data": {
    "reservationId": "RES500",
    "orderId": "ORD900",
    "storeId": "STORE101",
    "sku": "LAPTOP001",
    "quantity": 2
  }
}

Required contract fields:

- eventId: Stable unique event identity
- eventType: Business event name
- eventVersion: Event schema version
- occurredAt: Event occurrence timestamp
- data: Event-specific business payload

## 5. Event Identity and Deduplication

Amazon EventBridge and SQS consumers must be designed
to tolerate duplicate deliveries.

Each consumer maintains a durable processed-event record.

Processing must coordinate:

1. Checking event identity
2. Applying the business effect
3. Recording successful processing

The business effect and deduplication record should be
committed atomically when they share a transactional store.

Otherwise, an equivalent reliable processing pattern
must prevent repeated business effects.

## 6. Event Ordering

Events may arrive out of order.

The proposed future contract extension includes:

- aggregateId
- aggregateVersion

Example:

{
  "aggregateId": "STORE101#LAPTOP001",
  "aggregateVersion": 11
}

The consumer must not overwrite newer state using an older
aggregate version.

If a required version is missing, the consumer should
pause, buffer, or reconcile according to its consistency
requirements.

These fields are not yet included in the committed
Phase 6 InventoryReserved JSON Schema.

## 7. Schema Evolution

Event schemas must be versioned and tested for compatibility.

General principles:

- Prefer backward-compatible additions.
- Avoid silently removing required fields.
- Avoid changing field types without migration.
- Maintain consumer compatibility during transitions.
- Validate event contracts in CI/CD.
- Document breaking changes and migration plans.

Optional fields are only safely backward-compatible when
existing consumers tolerate unknown fields.

## 8. Delivery and Failure Recovery

Consumers must implement:

- Bounded retry policies
- Exponential backoff where appropriate
- Dead-letter queues
- Operational alerting
- Safe message redrive
- Idempotent business processing

EventBridge target delivery failures require appropriate
retry and dead-letter handling separate from SQS consumers.

Exactly-once delivery is not assumed.

## 9. Transactional Outbox

The Reservation Service records the event publication
intent in the same DynamoDB transaction as the reservation.

A publisher later sends the event to EventBridge.

Publisher retries can cause duplicate deliveries.

Consumers must therefore remain idempotent.

DynamoDB Streams may support the publisher implementation,
but durable recovery must account for stream retention
and processing failures.

## 10. Analytical Event Ingestion

Analytics ingestion writes events to Amazon S3.

The proposed data lake uses:

- Bronze: Raw events
- Silver: Validated and deduplicated records
- Gold: Business-ready analytical aggregates

Event identity and schema versions should be preserved
to support replay, lineage, and reconciliation.

## 11. Event Observability

Monitor:

- Publication failures
- Event processing latency
- Consumer backlog
- Duplicate detection rates
- Invalid schema counts
- DLQ message counts
- Event age and freshness
- Reconciliation failures

Correlation identifiers should support tracing events
across services without exposing sensitive data.

## 12. Contract Testing

Required tests include:

1. Valid InventoryReserved event
2. Missing required fields
3. Invalid quantity
4. Duplicate event delivery
5. Out-of-order event delivery
6. Schema version compatibility
7. Consumer failure and retry
8. DLQ routing and redrive
9. Publisher recovery
10. Analytical replay and deduplication

## 13. Open Questions

- Aggregate version ownership and generation
- Event schema registry selection
- Event retention and replay requirements
- Cross-service correlation strategy
- Consumer idempotency retention
- DLQ ownership and recovery procedures
- Schema migration approval process
- Analytics reconciliation thresholds

## 14. Related Documents

- data-architecture.md
- dynamodb-data-model.md
- ../07-integration-design/inventory-reserved-event.schema.json
- ../../diagrams/data-architecture.mmd

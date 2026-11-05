# ADR-002: Inventory Reservation Database Selection

## Status
Proposed

## Context
NorthStar Retail requires an authoritative inventory reservation
database that prevents overselling across online and store channels.

Business requirements:
- Support concurrent reservation requests.
- Prevent negative available inventory.
- Provide low-latency store-and-SKU lookups.
- Support idempotent reservation requests.
- Handle peak shopping traffic.
- Maintain high availability.
- Minimize database administration.

Example:
Store 101 has five laptops available.

Two customers simultaneously request four laptops each.

Only one reservation may succeed.

## Options Considered

### Option 1: Amazon DynamoDB

Advantages:
- Fully managed NoSQL database.
- Atomic conditional writes.
- ACID transactions across multiple items.
- Low-latency key-based access.
- Managed capacity scaling.
- Multi-AZ regional resilience.

Tradeoffs:
- Requires careful partition-key design.
- Hot keys can create contention.
- Transactions have limits and additional costs.
- Complex relational queries are less convenient.

### Option 2: Amazon Aurora PostgreSQL

Advantages:
- ACID transactions.
- Relational constraints.
- SQL query flexibility.
- Familiar PostgreSQL ecosystem.

Tradeoffs:
- Requires instance and connection capacity planning.
- Scaling write-heavy workloads needs careful design.
- More database operational considerations.

### Option 3: Amazon RDS PostgreSQL

Advantages:
- Mature relational database.
- Transactional consistency.
- Broad PostgreSQL tooling support.

Tradeoffs:
- More infrastructure capacity management.
- Scaling and failover require careful configuration.

## Proposed Decision
Use Amazon DynamoDB as the authoritative reservation database.

Design inventory access around store-and-SKU identifiers.

Use atomic conditional updates to prevent inventory quantities
from falling below zero.

Use DynamoDB transactions where multiple records must change
atomically, including reservation and idempotency records.

## Reservation Consistency Design

Example inventory record:

StoreId: STORE-101
SKU: LAPTOP-001
AvailableQuantity: 5

Reservation request:
Quantity: 4

Conditional update:
Decrease AvailableQuantity by 4 only when
AvailableQuantity is greater than or equal to 4.

If two requests compete for the same five units,
at most one request for four units can succeed.

The reservation record and inventory adjustment must be
committed consistently.

## Idempotency Design
Each reservation request must include a stable idempotency key.

Repeated requests with the same key and equivalent payload
must return the original reservation outcome without allocating
inventory again.

Reusing a key with a conflicting payload must be rejected.

## Event Publication
A committed reservation must eventually produce its
corresponding business event.

The architecture must use a reliable publication mechanism,
such as a DynamoDB Streams-based outbox design or an equivalent
durable event-publication pattern.

A database commit must not depend on downstream consumer availability.

## Consequences

Positive:
- Managed database scaling.
- Atomic inventory enforcement.
- Reduced infrastructure administration.
- Efficient key-based operations.

Negative:
- Access-pattern-driven data modeling.
- Hot-item contention risks.
- Transaction limits and costs.
- Additional design required for event publication.

## Risks and Mitigations
- Hot inventory keys: measure contention and evaluate alternatives.
- Duplicate requests: enforce idempotency.
- Concurrent updates: use conditional writes or transactions.
- Lost events: implement reliable event publication.
- Capacity spikes: load-test and monitor throttling.

## Validation Criteria
- Prove no overselling under concurrent requests.
- Verify duplicate requests do not allocate twice.
- Test transaction failure and retry behavior.
- Measure p95 and p99 reservation latency.
- Test peak throughput and hot-key contention.
- Validate event publication after successful commits.
- Estimate normal and peak transaction costs.

## Related Decisions
- ADR-001: Compute Platform
- ADR-003: Event Messaging
- ADR-004: API Integration

## Approval
Pending architecture review.

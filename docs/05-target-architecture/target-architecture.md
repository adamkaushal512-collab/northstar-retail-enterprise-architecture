# NorthStar Retail — Target-State Solution Architecture

**Phase:** 4 — Target-State Solution Architecture  
**Status:** Proposed — pending technical validation and stakeholder approval

## 1. Executive Summary

NorthStar Retail will modernize its omnichannel architecture to improve inventory accuracy, prevent conflicting reservations, reduce order cancellations, and support peak retail demand.

The proposed design introduces authoritative inventory allocation, explicit service ownership, reliable event-driven integration, and operational resilience.

Technology selection and formal Architecture Decision Records will be completed in Phase 5.

## 2. Business Objectives

| Metric | Illustrative Baseline | Target |
|---|---|---|
| Inventory accuracy | 85% | 98% |
| Order cancellations | 8% | Below 2% |
| Order processing time | 15 minutes | Below 5 minutes |
| Critical service availability | 99.5% | 99.95% |
| Peak throughput | 10,000 orders/hour | 50,000 orders/hour |

These targets require stakeholder validation.

## 3. Architecture Principles

1. Authoritative inventory allocation and atomic reservation operations.
2. API-first service interfaces and explicit ownership.
3. Event-driven integration for downstream updates.
4. Resilience, idempotency, and failure recovery by design.
5. Least-privilege security, encryption, and auditability.
6. End-to-end observability and measurable business outcomes.

## 4. Proposed Architecture Components

| Component | Responsibility |
|---|---|
| E-commerce | Customer shopping and checkout |
| POS | In-store transactions and stock changes |
| API / Integration Layer | Service routing, authentication, and contracts |
| OMS | Order lifecycle and reservation requests |
| Inventory Reservation Service | Authoritative reservation coordination |
| Inventory Store | Atomic inventory and reservation state |
| Event Publication | Reliably record and publish committed changes |
| Event Distribution | Deliver events to interested consumers |
| Online Inventory View | Read-optimized inventory availability |
| Store Fulfillment | BOPIS picking and customer handoff |
| WMS | Warehouse inventory operations |
| Analytics | Operational reporting and business insights |

These are logical components; specific products and deployment technologies are not yet selected.

## 5. Inventory Reservation Design

The OMS requests a reservation using an idempotency key.

The Reservation Service:

1. Validates the request and authorization.
2. Checks authoritative inventory availability.
3. Atomically allocates the requested quantity.
4. Persists reservation identity and lifecycle state.
5. Records an event for reliable publication.
6. Returns success or a defined failure response.

Concurrent requests must not allocate more inventory than is available.

Retries using the same idempotency key must not create additional allocations.

Reservation expiration and cancellation must release inventory safely and exactly once at the business-state level.

If the authoritative allocation system is unavailable, the service must not falsely confirm a reservation.

## 6. Event-Driven Integration

Immediate reservation decisions use synchronous service requests.

Committed inventory changes are propagated asynchronously to downstream consumers.

Proposed event types include:

- InventoryReserved
- ReservationReleased
- ReservationExpired
- InventoryAdjusted
- InventoryReconciled

Events require stable identities, schema versions, correlation identifiers, and appropriate entity ordering/version information.

A transactional outbox or equivalent reliable publication mechanism should be evaluated.

Consumers must support duplicate delivery, retries, out-of-order messages, and reconciliation.

Downstream read-model failure must not automatically reverse a successfully committed reservation.

## 7. Offline POS and Reconciliation

Offline POS sales present a special consistency challenge.

The target design must define:

- Whether stores can allocate inventory while disconnected.
- Any store-level stock allocation limits or protected inventory pools.
- Reconnection and conflict-resolution policies.
- Reconciliation ownership and exception handling.
- Auditability of adjustments and disputed allocations.

The final policy requires business and technical approval.

## 8. Scalability and Performance

Design for approximately 50,000 orders per hour, including bursts above the hourly average.

Evaluate:

- Stateless service horizontal scaling.
- Database contention and hot inventory records.
- Controlled concurrency and backpressure.
- Queue buffering and downstream capacity.
- Load, stress, and concurrency testing.
- p50, p95, and p99 latency objectives.

Correctness must not be sacrificed to increase throughput.

## 9. Resilience and Reliability

Evaluate:

- Multi-Availability-Zone deployments.
- Safe timeouts, bounded retries, and circuit breakers.
- Idempotent request and event processing.
- Recovery and reconciliation procedures.
- Defined RTO/RPO and availability objectives.
- Failure injection and operational runbooks.

## 10. Security

Apply:

- Strong service and user authentication.
- Least-privilege authorization.
- Encryption in transit and at rest.
- Managed secrets and credential rotation.
- Audit trails for reservation and inventory changes.
- Security monitoring and compliance validation.

## 11. Observability

Monitor:

- Reservation success and rejection rates.
- Inventory oversell incidents.
- Reservation API p95/p99 latency.
- Inventory event processing lag.
- Failed events and retry volume.
- Inventory reconciliation discrepancies.
- Order cancellations and business outcomes.

## 12. Architecture Tradeoffs

| Decision | Benefit | Tradeoff |
|---|---|---|
| Dedicated Reservation Service | Centralized allocation rules | Additional service complexity |
| Atomic inventory allocation | Prevents conflicting reservations | Potential database contention |
| Event-driven integration | Decouples downstream consumers | Eventual consistency and recovery complexity |
| Reliable event publication | Reduces lost-event risk | Additional persistence and monitoring |
| Multi-AZ deployment | Improved availability | Additional cost |

## 13. Requirements Traceability

| Requirement | Proposed Architecture Capability |
|---|---|
| FR-005 | Atomic authoritative inventory allocation |
| FR-009 | Offline POS reconciliation |
| NFR-001 | Resilient critical services |
| NFR-003 | Horizontal scaling and capacity validation |
| NFR-006 | Strong allocation consistency and defined read-model freshness |
| NFR-007 | Logs, metrics, traces, and alerting |
| SEC-001 | Authenticated and authorized service access |

## 14. Open Decisions

Phase 5 will evaluate:

1. Compute platform: Lambda, ECS Fargate, or EKS.
2. Authoritative database: DynamoDB, Aurora, or another suitable store.
3. Event distribution: EventBridge, SNS/SQS, MSK, or alternatives.
4. API gateway and integration approaches.
5. Cost, performance, operational complexity, and security tradeoffs.

## 15. Validation and Approval

This architecture is a proposed learning-project design, not a production-approved solution.

Required next steps:

- Validate system and data ownership.
- Confirm offline POS operating policies.
- Review service-level targets and business priorities.
- Prototype concurrent inventory reservations.
- Review architecture tradeoffs with simulated stakeholders.
- Record formal technology decisions in Phase 5.

## 16. Phase 4 Coverage

- 4A — Architecture Principles: Covered
- 4B — Target Components: Covered
- 4C — Inventory Reservation: Covered
- 4D — Event-Driven Integration: Covered
- 4E — Resilience, Scalability, Security, Observability: Covered
- 4F — Architecture Diagrams and Tradeoffs: Covered
- 4G — Documentation and GitHub: In progress

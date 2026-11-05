# NorthStar Retail — Integration & API Architecture

**Status:** Proposed — pending engineering and stakeholder review.

## 1. Purpose and Scope

Define integration contracts, communication patterns, security,
reliability, observability, and failure recovery for the NorthStar
Retail omnichannel commerce platform.

The primary integration is OMS to Inventory Reservation Service.
Other systems include POS, WMS, Store Fulfillment, Online Inventory
View, and Analytics.

## 2. Integration Architecture

### Synchronous communication

OMS calls the Inventory Reservation Service over HTTPS through
an internal Application Load Balancer.

- Endpoint: POST /v1/reservations
- API specification: reservation-api.yaml
- Required header: Idempotency-Key
- Authentication: proposed OAuth 2.0 client credentials
- Successful creation: HTTP 201
- Successful idempotent replay: HTTP 200
- Inventory or idempotency conflict: HTTP 409

The OMS must verify reservation success before confirming inventory.

### Asynchronous communication

After a reservation commits, the service publishes an
InventoryReserved event through a reliable outbox mechanism.

EventBridge routes events to independent SQS queues for:

- Online Inventory View
- Store Fulfillment
- Analytics

Each consumer processes events independently.

Event contract: inventory-reserved-event.schema.json

## 3. Authoritative Inventory and Consistency

The Inventory Reservation Service owns reservation decisions.

DynamoDB conditional writes or transactions enforce available
inventory constraints and prevent overselling.

The Online Inventory View is eventually consistent and cannot
authorize inventory reservations.

## 4. Idempotency

OMS reuses the same Idempotency-Key for retries of the same
logical operation.

The service must durably and atomically coordinate the idempotency
record with the reservation transaction.

Reusing a key with a different request payload is rejected.

Consumers must also deduplicate repeated event deliveries.

## 5. Reliable Event Publication

A transactional outbox or equivalent durable mechanism records
the business change and publication intent consistently.

A publisher sends committed events to EventBridge.

Publication failures require bounded retries, durable recovery,
monitoring, and operator intervention where necessary.

DynamoDB Streams may support publication but must not be treated
as an unlimited retry store.

Exactly-once event delivery is not assumed.

## 6. Failure Recovery

### API timeouts

A timeout does not establish whether the reservation committed.

OMS retries with the same idempotency key or uses an approved
status reconciliation mechanism.

### Retry strategy

Transient failures use bounded exponential backoff with jitter,
maximum attempts, and timeout budgets.

Business conflicts are not blindly retried.

### Circuit breakers

OMS limits calls to unhealthy dependencies.

An unknown reservation outcome must not be treated as success.

### Dead-letter queues

SQS consumer failures are retried according to configured policies.

Messages exceeding the maximum receive count are sent to a DLQ.

Operators investigate, fix, and safely redrive failed messages.

EventBridge target delivery failures require separate handling.

### Ordering and duplicate delivery

Consumers must tolerate duplicate and out-of-order events.

Aggregate identifiers and monotonic aggregate versions can
prevent stale state changes from overwriting newer state.

Event schema versions and aggregate versions are distinct.

## 7. Offline POS Reconciliation

Offline POS transactions must be durably recorded and reconciled
when connectivity returns.

The workflow must address duplicates, delayed updates, conflicts,
and exceptions requiring human review.

Offline reconciliation cannot bypass authoritative inventory rules.

## 8. Security

- Private networking and restrictive security groups
- HTTPS and appropriate TLS termination or re-encryption
- Workload authentication and service-level authorization
- Least-privilege IAM for AWS resource access
- AWS Secrets Manager for sensitive credentials
- Structured security and business audit records
- No credentials or unnecessary personal data in logs

An ECS task role does not automatically authenticate a custom
HTTP API caller.

## 9. Observability

Instrument the integration path using:

- Structured logs and correlation identifiers
- Distributed traces
- Request counts and error rates
- p50, p95, and p99 latency
- Reservation success and conflict rates
- Event publication failures
- SQS queue backlog and DLQ depth
- Alerts and operational dashboards

Proposed AWS tooling includes CloudWatch and OpenTelemetry/X-Ray.

## 10. Integration Testing

Required scenarios:

1. Successful reservation
2. Invalid request and insufficient inventory
3. Authentication and authorization failures
4. Concurrent reservation contention
5. Duplicate API requests
6. Timeout after a successful commit
7. Event publication failure and recovery
8. Duplicate and out-of-order event processing
9. DLQ routing and safe redrive
10. Offline POS reconciliation
11. OpenAPI contract compatibility
12. Consumer outage and recovery

## 11. Architecture Decision Alignment

- ADR-001: Amazon ECS with AWS Fargate
- ADR-002: Amazon DynamoDB
- ADR-003: Amazon EventBridge and SQS
- ADR-004: Internal ALB and REST API

These architecture decisions remain proposed until approved.

## 12. Open Questions

- Identity provider and token validation design
- API timeouts, rate limits, and retry budgets
- DynamoDB hot-key and contention mitigation
- Outbox publisher implementation and recovery
- Aggregate versioning and event ordering
- Idempotency record retention
- DLQ ownership, alerting, and redrive policy
- Offline POS conflict resolution
- Contract testing and CI/CD integration
- Performance and resilience validation

## 13. Next Phases

- Phase 7: Data Architecture and Event-Driven Systems
- Phase 8: Security, Compliance, and Governance
- Phase 9: AWS Infrastructure and Terraform
- Phase 10: AI/ML Architecture
- Phase 11: Engineering Collaboration and Implementation

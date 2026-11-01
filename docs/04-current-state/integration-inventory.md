# NorthStar Retail — Current-State Integration Inventory

## Purpose

Document preliminary system integrations identified during Phase 1.

This is a simulated discovery artifact. Reported relationships are not independently verified technical interfaces.

## Integration Inventory

| ID | Source | Destination | Data | Mechanism / Frequency | Status |
|---|---|---|---|---|---|
| INT-001 | POS | Store Inventory | Sales and stock changes | Exact mechanism unknown | Stakeholder-reported |
| INT-002 | Store Inventory | Online Inventory View | Store availability | Periodic synchronization; reported delays of 10–15 minutes | Stakeholder-reported |
| INT-003 | E-commerce | OMS | Online order requests | Interface details unknown | Stakeholder-reported |
| INT-004 | OMS | Online Inventory View | Availability lookup | API contract and consistency unknown | Stakeholder-reported |
| INT-005 | WMS | Inventory ecosystem | Warehouse stock changes | Flow and mechanism unknown | Candidate |
| INT-006 | OMS | Store Fulfillment | BOPIS fulfillment requests | Flow and mechanism unknown | Candidate |

## Known Integration Risks

- Delayed inventory synchronization.
- Duplicate or out-of-order inventory events.
- Unclear cross-channel reservation coordination.
- Unknown retry and timeout policies.
- Unverified idempotency guarantees.
- Incomplete observability and reconciliation.
- Legacy system interface capacity limitations.

## Required Validation

For every integration, confirm:

1. Source and destination systems.
2. Responsible technical and business owners.
3. Protocol and API or event contract.
4. Data schema and identifier mappings.
5. Synchronization frequency and latency distribution.
6. Retry, timeout, and failure-handling behavior.
7. Authentication and authorization.
8. Monitoring, alerting, and reconciliation.
9. Peak throughput and capacity limits.

## Architecture Guidance

Do not select Kafka, EventBridge, SQS, or another integration technology until functional, nonfunctional, operational, and business requirements are established.

## Status

Phase 1 preliminary integration inventory. Pending stakeholder and technical validation.

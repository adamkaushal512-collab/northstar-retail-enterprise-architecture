# NorthStar Retail — Current-State Architecture Assessment

**Phase:** 3 — Current-State Architecture Assessment
**Status:** Draft — simulated assessment, pending technical validation

## 1. Executive Summary

NorthStar Retail's current omnichannel architecture has fragmented inventory visibility, periodic synchronization, and no confirmed authoritative cross-channel reservation mechanism.

These conditions create risks of stale availability, overselling, order cancellations, and operational recovery difficulties.

The highest-priority finding is GAP-001: Missing unified reservation ownership.

## 2. Business Context

Illustrative discovery baselines and targets:

| Metric | Current Baseline | Target |
|---|---|---|
| Inventory accuracy | ~85% | 98% |
| Order cancellation rate | ~8% | Below 2% |
| Order processing time | ~15 minutes | Below 5 minutes |
| Critical service availability | ~99.5% | 99.95% |
| Peak order throughput | ~10,000 orders/hour | 50,000 orders/hour |

These figures require stakeholder validation.

## 3. Current Systems

| System | Assumed Responsibility | Assessment |
|---|---|---|
| E-commerce Storefront | Online customer experience | Integration with OMS reported |
| OMS | Order lifecycle | Reservation coordination unclear |
| Online Inventory View | Online availability read model | Potentially stale inventory |
| POS | In-store transactions | Inventory update mechanism unknown |
| Store Inventory | Store stock records | Periodic downstream synchronization |
| WMS | Warehouse operations | Integration not confirmed |
| Store Fulfillment | BOPIS execution | Integration not confirmed |

System ownership and authoritative data boundaries require validation.

## 4. Integration Assessment

| ID | Integration | Finding |
|---|---|---|
| INT-001 | POS to Store Inventory | Protocol and failure behavior unknown |
| INT-002 | Store Inventory to Online Inventory View | Reported 10–15 minute synchronization delays |
| INT-003 | E-commerce to OMS | Interface contract and idempotency unknown |
| INT-004 | OMS to Online Inventory View | Consistency guarantees unknown |
| INT-005 | WMS to Inventory Ecosystem | Candidate integration; unverified |
| INT-006 | OMS to Store Fulfillment | Candidate integration; unverified |

Reference: docs/04-current-state/integration-inventory.md

## 5. Architecture Gap Register

| ID | Gap | Business Impact | Preliminary Priority |
|---|---|---|---|
| GAP-001 | Missing unified reservation ownership | Overselling and cancellations | Critical |
| GAP-002 | Delayed inventory synchronization | Stale availability | High |
| GAP-003 | Unverified retry and idempotency guarantees | Duplicate or inconsistent processing | High |
| GAP-004 | Incomplete integration observability | Slow incident detection and recovery | High |
| GAP-005 | Unclear interface contracts and ownership | Integration and change risks | Medium |
| GAP-006 | Unverified peak-load capacity | Black Friday degradation | High |

GAP-002 through GAP-006 are preliminary assessment findings. Their exact severity requires validation.

## 6. Scalability Assessment

The target peak throughput is approximately 50,000 orders per hour.

Assessment activities:
- Measure peak and burst transaction rates.
- Identify processing and synchronization bottlenecks.
- Validate upstream and downstream capacity.
- Evaluate buffering and backpressure requirements.
- Load-test critical order and inventory paths.

No specific cloud integration technology has been selected.

## 7. Security Assessment

Validate:
- Service authentication and authorization.
- Least-privilege access to inventory adjustments.
- Encryption in transit and at rest.
- Secrets and credential management.
- Audit logging and retention.
- Applicable privacy and compliance requirements.

Current control implementation has not been independently verified.

## 8. Reliability Assessment

Validate:
- Timeout and retry policies.
- Stable event identities and idempotent processing.
- Out-of-order event handling.
- Failure recovery and reconciliation.
- Monitoring, alerting, and incident ownership.
- Recovery time and recovery point objectives.

## 9. Illustrative Failure Scenario

1. Store Inventory records five available laptops.
2. POS sells four laptops.
3. Online Inventory View remains stale.
4. OMS checks the stale view and may accept an order for three laptops.
5. Inventory synchronization eventually reveals the discrepancy.

This scenario illustrates a potential failure, not a verified production incident.

## 10. Recommendations for Phase 4

1. Define authoritative cross-channel reservation ownership.
2. Design atomic reservation and inventory allocation boundaries.
3. Define inventory consistency and freshness requirements.
4. Evaluate resilient integration and reconciliation patterns.
5. Design observability, security, and operational controls.
6. Validate architecture decisions against business objectives and NFRs.

## 11. Open Validation Questions

- Which system is authoritative for physical stock?
- How are POS and OMS inventory allocations coordinated today?
- What happens during offline POS transactions?
- What are actual synchronization latency percentiles?
- Which integrations use synchronous APIs versus asynchronous events?
- What retry, timeout, and deduplication mechanisms exist?
- What are current throughput and failure rates?
- Who owns each interface and operational incident?

## 12. Assessment Status

Steps 3A–3F: Covered at introductory level.

Step 3G: Documentation and GitHub publication in progress.

**Stakeholder signoff:** Not obtained; simulated learning project.

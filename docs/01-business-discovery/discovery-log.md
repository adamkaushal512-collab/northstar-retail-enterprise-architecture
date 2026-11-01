# NorthStar Retail — Phase 1 Discovery Log

## Purpose

Track findings, assumptions, risks, and open questions identified during simulated business and technical discovery.

All stakeholder-reported information is fictional and requires independent validation before being treated as production evidence.

## Business and Workflow Discovery

| ID | Finding | Status |
|---|---|---|
| DISC-001 | Inventory synchronization may take 10–15 minutes | Reported |
| DISC-002 | E-commerce uses a separate inventory view | Reported |
| DISC-003 | Cross-channel atomic reservation is missing | Reported |
| DISC-004 | Overselling contributes to order cancellations | Reported |
| DISC-005 | Legacy systems require incremental modernization | Constraint |
| DISC-006 | Physical stock and online availability differ | Reported |
| DISC-007 | Availability calculations vary across systems | Reported |
| DISC-008 | Inventory synchronization relies on batch processing | Reported |
| DISC-009 | Duplicate or delayed updates may contribute to discrepancies | Hypothesis |

## Inventory Ownership and Definitions

| ID | Finding | Status |
|---|---|---|
| DISC-010 | Cross-channel reservation ownership unclear | Gap |
| DISC-011 | Enterprise ATP ownership not established | Gap |
| DISC-012 | Offline POS reconciliation requires investigation | Open |
| DISC-013 | Common inventory identifiers and event contracts need validation | Open |

## Existing Systems and Integrations

| ID | Finding | Status |
|---|---|---|
| DISC-014 | APIs and batch integrations coexist | Reported |
| DISC-015 | Integration ownership and documentation incomplete | Reported |
| DISC-016 | POS connectivity interruptions may delay updates | Risk |
| DISC-017 | Synchronization latency distribution not measured | Evidence gap |
| DISC-018 | Retry, deduplication, and dead-letter handling unverified | Open |
| DISC-019 | OMS lookup timeout behavior unknown | Open |
| DISC-020 | WMS and store fulfillment integrations require investigation | Open |
| DISC-021 | Reservation timeout may leave operation outcome unknown | Scenario |
| DISC-022 | Reservation idempotency guarantees need validation | Open |
| DISC-023 | Retry budgets and timeout policies need review | Open |
| DISC-024 | Dead-letter and replay capabilities need investigation | Open |
| DISC-025 | Reconciliation and observability requirements need definition | Open |
| DISC-026 | Duplicate events could cause repeated stock adjustments | Risk |
| DISC-027 | Stable event IDs needed for deduplication | Candidate requirement |
| DISC-028 | Processed-event records and stock mutations require atomic consistency | Candidate requirement |
| DISC-029 | Duplicate-delivery and crash-recovery tests are needed | Test requirement |

## Constraints, Risks, and Dependencies

| ID | Finding | Status |
|---|---|---|
| DISC-030 | Checkout and BOPIS continuity are mandatory | Constraint |
| DISC-031 | Promotions and holidays elevate deployment risk | Reported |
| DISC-032 | Delivery budget and timeline are not approved | Open |
| DISC-033 | Legacy interface capacity and compatibility unverified | Open |
| DISC-034 | Migration fallback and rollback requirements undefined | Open |
| DISC-035 | Baseline monitoring and recovery requirements need validation | Open |
| DISC-036 | Degraded checkout differs from cross-channel availability | Candidate requirement |
| DISC-037 | Uncertain BOPIS promises require restrictions or manual verification | Candidate requirement |
| DISC-038 | Offline replay must avoid duplicate stock changes | Candidate requirement |
| DISC-039 | Rollback requires inventory and reservation reconciliation | Candidate requirement |
| DISC-040 | Recovery and degraded-mode exit criteria require approval | Open |

## Architecture Documentation

| ID | Finding | Status |
|---|---|---|
| DISC-041 | Diagrams must distinguish reported from candidate relationships | Documentation rule |
| DISC-042 | Unified reservation ownership is a gap, not an existing service | Gap |
| DISC-043 | OMS queries the online inventory view | Diagram clarification |
| DISC-044 | Physical infrastructure and deployment topology remain unverified | Open |

## Discovery Summary

- Total entries: 44
- Architecture gaps identified: 6
- Preliminary integrations documented: 6
- Target-state technology decisions: None approved

## Next Steps

1. Validate stakeholder-reported findings.
2. Confirm integration contracts and system ownership.
3. Define measurable requirements.
4. Evaluate architecture risks and dependencies.
5. Use validated evidence to inform future ADRs.

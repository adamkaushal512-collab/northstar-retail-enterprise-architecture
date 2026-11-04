# NorthStar Retail — Enterprise Architecture Requirements

**Phase:** 2 — Functional and Nonfunctional Requirements
**Status:** Draft — simulated stakeholder review pending

## 1. Business Objectives

- Improve inventory accuracy from approximately 85% toward 98%.
- Reduce order cancellations from approximately 8% to below 2%.
- Reduce order processing time from approximately 15 minutes to below 5 minutes.
- Improve availability of critical commerce services.
- Support peak demand of approximately 50,000 orders per hour.

All baselines and targets are project assumptions requiring validation.

## 2. Functional Requirements

| ID | Requirement |
|---|---|
| FR-001 | Provide cross-channel inventory visibility. |
| FR-002 | Calculate available-to-promise inventory. |
| FR-003 | Reserve eligible inventory for customer orders. |
| FR-004 | Propagate inventory availability updates. |
| FR-005 | Prevent overselling during concurrent reservations. |
| FR-006 | Release inventory when reservations are cancelled. |
| FR-007 | Expire reservations according to approved policies. |
| FR-008 | Synchronize inventory changes across sales channels. |
| FR-009 | Recover and reconcile offline POS transactions. |
| FR-010 | Support controlled inventory adjustments and auditing. |
| FR-011 | Handle BOPIS fulfillment exceptions. |
| FR-012 | Support interlocation inventory transfers. |

## 3. Nonfunctional Requirements

| ID | Requirement |
|---|---|
| NFR-001 | Define and measure service-specific availability targets. |
| NFR-002 | Define p50, p95, and p99 latency objectives under agreed workloads. |
| NFR-003 | Support planned peak demand and validate scalability through testing. |
| NFR-004 | Handle transient failures with idempotency, bounded retries, and recovery. |
| NFR-005 | Define service-specific recovery time and recovery point objectives. |
| NFR-006 | Enforce authoritative allocation consistency and defined data freshness. |
| NFR-007 | Provide metrics, structured logs, distributed traces, and actionable alerts. |
| NFR-008 | Enforce authentication, least privilege, authorization, and auditing. |
| NFR-009 | Support maintainable changes, safe deployments, runbooks, and recovery. |

Numeric service-level targets remain subject to stakeholder approval.

## 4. Business Rules

| ID | Rule |
|---|---|
| BR-001 | Reservations must not exceed authoritative available inventory. |
| BR-002 | Concurrent allocations must be atomic. |
| BR-003 | Expired reservations must release inventory safely. |
| BR-004 | Cancelled reservations must not release inventory more than once. |
| BR-005 | Reservation lifecycle transitions must be traceable. |
| BR-006 | Repeated requests must not create duplicate reservations. |

### Acceptance Criteria Example

**Given** five units are available at a store,

**When** two customers simultaneously request four units each,

**Then** no more than one request succeeds, the other receives an insufficient-inventory response, and the remaining available quantity is one.

## 5. Data and Integration Requirements

- Identify authoritative systems of record for inventory, orders, payments, and store transactions.
- Define API contracts and event schemas with versioning.
- Support synchronous requests and asynchronous event-driven integration.
- Define consistency and freshness expectations.
- Deduplicate repeated events using stable identities.
- Handle out-of-order delivery, retries, failures, and reconciliation.
- Validate data quality and completeness.
- Define ownership of integration failures and recovery procedures.

## 6. Security and Compliance Requirements

| ID | Requirement |
|---|---|
| SEC-001 | Enforce authenticated access and approved role-based permissions. |
| SEC-002 | Encrypt sensitive data at rest and in transit. |
| SEC-003 | Protect credentials using approved secrets management. |
| SEC-004 | Audit privileged and sensitive operations. |
| SEC-005 | Define applicable privacy, retention, and compliance controls. |
| SEC-006 | Validate security controls through testing and periodic review. |

## 7. Proposed MoSCoW Prioritization

| Capability | Priority |
|---|---|
| Accurate inventory availability | Must |
| Atomic inventory reservation | Must |
| Offline POS reconciliation | Must |
| Automated inventory reconciliation | Should |
| AI demand forecasting | Could |
| Personalized recommendations | Won't — initial release |

Priorities are proposals, not stakeholder-approved commitments.

## 8. Requirements Traceability Matrix

| Business Objective | Requirement | Proposed Architecture Capability | Validation |
|---|---|---|---|
| Reduce order cancellations | FR-005 | Authoritative atomic reservations | Concurrent reservation testing |
| Improve inventory accuracy | FR-004, FR-008 | Cross-channel inventory synchronization | Reconciliation and freshness tests |
| Improve availability | NFR-001 | Resilient critical commerce services | Availability and failover tests |
| Protect sensitive data | SEC-002 | Encryption controls | Security configuration validation |
| Improve operational recovery | NFR-007, NFR-009 | Observability and operational runbooks | Incident simulation |

## 9. Open Questions and Approval Status

- Confirm business baselines and success metrics.
- Confirm service-specific latency, availability, and recovery targets.
- Confirm inventory authority and offline POS consistency policies.
- Validate data ownership, integration dependencies, and security obligations.
- Review priorities, costs, risks, and release scope with stakeholders.
- Obtain formal approval before treating this draft as a baseline.

**Approval status:** Pending — simulated learning project.

## 10. Phase 2 Coverage

- 2A — Functional Requirements: Covered
- 2B — Nonfunctional Requirements: Covered
- 2C — Business Rules and Acceptance Criteria: Covered
- 2D — Data and Integration Requirements: Covered
- 2E — Security and Compliance Requirements: Covered
- 2F — Requirements Prioritization: Covered
- 2G — Requirements Traceability and Validation: Covered
- 2H — Documentation and GitHub: In progress


# NorthStar Retail — Constraints, Risks, Assumptions and Dependencies

## Purpose

Record the preliminary constraints, architecture risks, assumptions, and dependencies identified during Phase 1.

This is a simulated discovery artifact. Risk ratings and ownership assignments are provisional and require stakeholder validation.

## 1. Constraints Register

| ID | Constraint | Status |
|---|---|---|
| CON-001 | Store checkout continuity during modernization | Reported |
| CON-002 | BOPIS fulfillment continuity | Reported |
| CON-003 | Incremental legacy modernization | Reported |
| CON-004 | Promotion and holiday change controls | Reported |
| CON-005 | Budget and delivery timeline approval outstanding | Open |
| CON-006 | Legacy interface compatibility and capacity | Validation required |
| CON-007 | Degraded-mode business rules require approval | Proposed |

## 2. Architecture Risk Register

| ID | Risk | Impact | Likelihood | Proposed Owner | Mitigation / Next Action |
|---|---|---|---|---|---|
| RISK-001 | Inventory discrepancies and overselling | High | High | Inventory Engineering | Validate inventory calculations and reconciliation |
| RISK-002 | Checkout disruption during modernization | Critical | Unknown | Retail Operations / POS | Define fallback, coexistence, and rollback |
| RISK-003 | Duplicate or delayed inventory events | High | Unknown | Data / Inventory Engineering | Investigate event handling and idempotency |
| RISK-004 | Legacy integration capacity limitations | High | Unknown | Integration / Application Teams | Assess throughput and API limits |
| RISK-005 | Unfunded or unrealistic delivery scope | High | Unknown | Product / Sponsor | Validate budget, milestones, and staffing |
| RISK-006 | Insufficient observability | High | Unknown | SRE / Data Engineering | Define monitoring and baseline measurements |
| RISK-007 | Unsafe fallback or rollback causing inventory divergence | Critical | Unknown | Retail Operations / Inventory | Define reconciliation and recovery criteria |

## 3. Assumptions Register

| ID | Assumption | Validation Required |
|---|---|---|
| ASM-001 | Existing systems can support phased modernization | Confirm technical and operational feasibility |
| ASM-002 | Inventory identifiers can be mapped across applications | Validate product and location identifiers |

## 4. Dependencies Register

| ID | Dependency | Responsible Stakeholders |
|---|---|---|
| DEP-001 | Validate POS-to-inventory update contracts | POS / Inventory Engineering |
| DEP-002 | Document reservation and allocation behavior | OMS Engineering |
| DEP-003 | Validate synchronization and reconciliation flows | Data Engineering |
| DEP-004 | Approve business metrics and investment constraints | Product Owner / Business Sponsor |
| DEP-005 | Validate security, audit, continuity, and recovery requirements | Security / Operations |
| DEP-006 | Approve degraded-mode procedures before a production pilot | Retail Operations / Store Operations |

## 5. Business Continuity Considerations

A future modernization rollout should evaluate:

- Pilot-store deployment with controlled scope.
- Approved local POS fallback behavior.
- Restrictions on uncertain online and BOPIS inventory promises.
- Durable handling of offline transactions.
- Idempotent replay of inventory changes.
- Inventory and reservation reconciliation.
- Explicit rollback triggers and recovery criteria.

These are candidate requirements, not approved production designs.

## 6. Risk Management Process

Each material risk should eventually have:

1. An accountable owner.
2. A validated likelihood and impact assessment.
3. A mitigation or acceptance decision.
4. Supporting evidence.
5. A target review date.
6. A documented escalation path.

## 7. Status

Preliminary Phase 1 register.

No risks have been formally accepted, and no target-state architecture decisions have been approved.

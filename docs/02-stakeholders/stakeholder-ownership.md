# NorthStar Retail — Stakeholder and System Ownership

## 1. Purpose

Document the key stakeholders, responsibilities, and preliminary system ownership identified during Phase 1 discovery.

All stakeholder statements and ownership assignments are simulated and require validation before being treated as authoritative enterprise records.

## 2. Stakeholder Register

| ID | Stakeholder | Responsibility |
|---|---|---|
| Me1 | VP of Retail Operations | Business outcomes, operational continuity, retail priorities |
| Me2 | Product Owner — Omnichannel Commerce | Product requirements, prioritization, business value |
| Me3 | Store Operations Manager | Store workflows, checkout, BOPIS operations |
| Me4 | Inventory Engineering Lead | Store inventory, stock changes, inventory integration |
| Me5 | POS Engineering Lead | Store checkout, POS transactions, inventory updates |
| Me6 | OMS Engineering Lead | Order lifecycle, allocations, reservations |
| Me7 | Data Engineering Lead | Data synchronization, reconciliation, data quality |

## 3. Preliminary System Ownership Matrix

| System | Primary Technical Owner | Main Responsibility | Status |
|---|---|---|---|
| POS | POS Engineering | Store transactions and sales | Reported |
| Store Inventory | Inventory Engineering | Recorded physical store stock | Reported |
| OMS | OMS Engineering | Online orders and allocations | Reported |
| E-commerce | Commerce Engineering — owner to confirm | Online shopping and order submission | Provisional |
| Online Inventory View | Commerce / Inventory / Data — owner to confirm | Online availability information | Unresolved |
| WMS | Warehouse Engineering — owner to confirm | Warehouse stock | Provisional |
| Store Fulfillment | Store Operations / OMS — owner to confirm | BOPIS fulfillment | Unresolved |

## 4. Ownership Gaps

- GAP-001: No unified cross-channel reservation ownership.
- GAP-002: Enterprise available-to-promise (ATP) ownership unresolved.
- Online inventory synchronization ownership requires clarification.
- Inventory reconciliation accountability requires confirmation.
- Integration incident response and escalation ownership require confirmation.

## 5. Decision Rights

The following responsibilities require formal confirmation:

- Retail Operations: Business continuity and degraded-mode approval.
- Product Owner: Business priority and scope recommendations.
- Engineering Owners: Technical implementation and system operation.
- Security and Compliance: Security and regulatory requirements.
- Principal Solution Architect: Cross-system architecture, tradeoff analysis, and architecture review coordination.

Architecture decisions requiring business funding, risk acceptance, or production authorization must be approved by the appropriate accountable stakeholders.

## 6. Next Actions

1. Confirm system and data owners.
2. Identify business owners for inventory availability policies.
3. Establish integration ownership and escalation paths.
4. Validate the proposed responsibility boundaries.
5. Record unresolved ownership questions for Phase 2.

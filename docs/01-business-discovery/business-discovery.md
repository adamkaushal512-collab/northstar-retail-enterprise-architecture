# NorthStar Retail — Business Discovery

## 1. Project Context

NorthStar Retail is a fictional enterprise retailer operating approximately 500 stores, an e-commerce platform, and Buy Online, Pick Up In Store (BOPIS) services.

This project simulates the responsibilities of a Principal Solution Architect, including business discovery, enterprise architecture, modernization, cloud, security, data, AI, implementation, and governance.

## 2. Business Problems

The initial stakeholder workshops identified:

- Inventory discrepancies between stores and online channels.
- Overselling caused partly by delayed inventory synchronization.
- Order cancellations due to inaccurate availability information.
- Slow order processing and fragmented system integrations.
- Limited cross-channel inventory reservation coordination.
- Operational risks during peak retail periods.

These findings are stakeholder-reported within the simulation and have not been independently validated.

## 3. Preliminary Business Metrics

| Metric | Reported Current | Desired Target |
|---|---|---|
| Inventory accuracy | 85% | 98% |
| Order cancellation rate | 8% | Below 2% |
| Average order processing time | 15 minutes | Below 5 minutes |
| Online platform availability | 99.5% | 99.95% |
| Peak order throughput | 10,000 orders/hour | 50,000 orders/hour |

Metric definitions, measurement methods, baselines, and target feasibility require validation.

## 4. Business Objectives

1. Improve inventory accuracy across retail channels.
2. Reduce order cancellations and overselling.
3. Improve order processing performance.
4. Support increased peak transaction volumes.
5. Maintain store checkout and BOPIS continuity.
6. Modernize legacy systems incrementally.
7. Improve operational visibility and auditability.

## 5. Initial Architecture Scope

The discovery scope includes:

- E-commerce storefront
- Point of Sale (POS)
- Order Management System (OMS)
- Store Inventory
- Warehouse Management System (WMS)
- Online inventory availability view
- Store fulfillment workflows
- Integration and data synchronization

## 6. Constraints and Assumptions

- Store checkout must remain operational during modernization.
- BOPIS continuity requires approved degraded-mode procedures.
- Legacy systems cannot all be replaced simultaneously.
- Delivery budget and timeline are not yet approved.
- Existing integration contracts and capacity require investigation.
- A phased modernization approach is assumed feasible but remains unvalidated.

## 7. Discovery Status

Phase 1 business discovery is documented as a preliminary simulated stakeholder assessment.

Architecture gaps, integration inventories, risk registers, and current-state diagrams are maintained as separate project artifacts.

No target-state technology selections have been approved.

## 8. Next Activities

- Consolidate stakeholder and system ownership information.
- Document integration flows and discovery findings.
- Review the current-state architecture diagram.
- Validate assumptions and unresolved risks.
- Complete Phase 1 review and GitHub commit.

# NorthStar Retail — Technology Decision Matrix

## Status
Proposed — Pending Architecture Review

## Purpose
Summarize the proposed technology selections for the
NorthStar Retail target-state architecture.

These selections require validation through implementation,
performance testing, cost analysis, and security review.

## Technology Decisions

| Architecture Layer | Proposed Technology | Alternatives | Primary Rationale | ADR |
|---|---|---|---|---|
| Compute | Amazon ECS with AWS Fargate | Lambda, EKS | Managed container deployment with lower operational complexity | ADR-001 |
| API Routing | Internal Application Load Balancer | API Gateway, direct service connectivity | Private REST routing and ECS integration | ADR-004 |
| Reservation Database | Amazon DynamoDB | Aurora PostgreSQL, RDS PostgreSQL | Atomic conditional writes and managed scaling | ADR-002 |
| Event Routing | Amazon EventBridge | SNS, MSK | Managed business-event routing and filtering | ADR-003 |
| Consumer Buffering | Amazon SQS | Direct event delivery, Kafka consumers | Durable queues and independent failure recovery | ADR-003 |
| Infrastructure as Code | Terraform | CloudFormation, CDK | Consistent infrastructure provisioning aligned with project requirements | Future Phase 9 design |

## Architecture Overview

Order Management System
    |
    v
Internal Application Load Balancer
    |
    v
Inventory Reservation Service
(Amazon ECS + AWS Fargate)
    |
    v
Amazon DynamoDB
    |
    v
Reliable Event Publisher
    |
    v
Amazon EventBridge
    |
    +--> Inventory SQS --> Online Inventory View
    |
    +--> Fulfillment SQS --> Store Fulfillment
    |
    +--> Analytics SQS --> Analytics Consumer

## Key Architecture Principles

1. Inventory reservations must be atomic.
2. Duplicate requests must not create duplicate reservations.
3. Committed reservations must eventually publish business events.
4. Downstream consumers must operate independently.
5. Event consumers must tolerate duplicate deliveries.
6. Services must support multi-AZ resilience.
7. Internal APIs must enforce authentication and authorization.
8. Infrastructure must be reproducible through automation.
9. Performance and cost assumptions must be validated.
10. Architecture decisions must remain traceable.

## Open Design Questions

- What DynamoDB partition-key strategy minimizes hot-key contention?
- How will reservation and idempotency records be modeled?
- What reliable event-publication mechanism will be implemented?
- What event ordering guarantees do consumers require?
- What authentication mechanism will protect internal APIs?
- What are the final latency and availability targets?
- How will Black Friday burst capacity be validated?
- What are the expected monthly and peak infrastructure costs?
- What disaster recovery strategy is required?

## Validation Plan

### Functional
- Verify successful inventory reservations.
- Prevent overselling during concurrent requests.
- Validate duplicate-request handling.
- Verify reservation cancellation and expiration.

### Performance
- Test expected peak order throughput.
- Measure p95 and p99 reservation latency.
- Evaluate DynamoDB hot-key contention.
- Measure event propagation delays.

### Reliability
- Simulate ECS task failures.
- Test Availability Zone failures.
- Verify consumer outage recovery.
- Test event publisher failure and replay.

### Security
- Validate service authentication and authorization.
- Verify TLS and private network boundaries.
- Review IAM permissions.
- Verify audit logging.

### Cost
- Estimate normal operating costs.
- Model peak-event costs.
- Evaluate Fargate baseline capacity.
- Evaluate DynamoDB transaction costs.
- Evaluate messaging request costs.

## Decision Governance

All four ADRs remain Proposed.

Formal acceptance would require the relevant engineering,
security, platform, and architecture stakeholders to review
the decisions and their supporting evidence.

This portfolio project does not represent actual enterprise
stakeholder approval.

## Next Phase

Phase 6 — Integration and API Architecture

Deliverables will include:
- REST API contracts using OpenAPI.
- Event schemas.
- Idempotency and retry contracts.
- Authentication and authorization design.
- Integration failure-recovery diagrams.

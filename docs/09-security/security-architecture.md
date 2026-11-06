# NorthStar Retail — Security Architecture

## 1. Purpose and Status

This document defines the proposed security architecture for the NorthStar Retail Enterprise Omnichannel Commerce Platform.

Status: Proposed design. Controls are not yet deployed or validated in AWS.

## 2. Security Principles

- Zero Trust: verify identities and authorize every sensitive operation.
- Defense in depth across network, identity, application, and data layers.
- Least privilege and separation of duties.
- Encryption at rest and in transit.
- Auditability, traceability, and secure failure handling.
- Minimize sensitive data exposure and blast radius.

## 3. Architecture Scope

Core components:
- Order Management System (OMS)
- Internal Application Load Balancer (ALB)
- Inventory Reservation Service on Amazon ECS Fargate
- Amazon DynamoDB for inventory, reservations, idempotency, and outbox records
- Outbox Publisher
- Amazon EventBridge
- Amazon SQS consumer queues
- Amazon S3 analytical data lake
- AWS Glue, Amazon Athena, and AWS Lake Formation

## 4. Identity and Access Management

- Assign dedicated IAM roles to ECS workloads.
- Separate ECS task roles from task execution roles.
- Use temporary credentials instead of embedded AWS access keys.
- Scope DynamoDB, S3, EventBridge, and SQS permissions to required resources and actions.
- Use IAM policies and applicable resource policies for authorization.
- Apply explicit-deny guardrails where appropriate.
- Audit IAM changes with AWS CloudTrail.
- Periodically review permissions and unused access.

## 5. Network Security

- Deploy workloads across multiple Availability Zones.
- Place application workloads in private subnets.
- Use an internal ALB for authorized private API traffic.
- Apply restrictive security groups between the ALB and ECS tasks.
- Use VPC endpoints for supported AWS services where appropriate.
- Restrict outbound network access.
- Use TLS for service communication.
- Define trust boundaries between OMS, the API, data stores, and event consumers.

## 6. Data Encryption and Key Management

- Encrypt S3 objects and DynamoDB data at rest.
- Use TLS for API traffic.
- Use AWS KMS for supported encryption requirements.
- Consider customer-managed KMS keys where governance requires additional control.
- Restrict KMS key usage through key policies and IAM permissions.
- Define key rotation, deletion safeguards, and recovery procedures.
- Review encryption requirements for SQS and EventBridge.

## 7. Secrets Management

- Store external API keys and required application secrets in AWS Secrets Manager.
- Retrieve secrets using authorized workload identities.
- Avoid storing credentials in source code, container images, or Terraform state.
- Rotate credentials according to approved procedures.
- Prefer IAM-based authentication over long-lived credentials where supported.
- Prevent secrets from appearing in application logs.

## 8. API and Application Security

- Authenticate service callers.
- Authorize operations independently of authentication.
- Validate request schemas, data types, and business constraints.
- Reject invalid reservation quantities.
- Use DynamoDB conditional writes or transactions to prevent overselling.
- Validate idempotency keys and protect against unintended replay.
- Apply request-size limits and appropriate rate limiting.
- Avoid leaking internal details in API errors.
- Scan dependencies and container images for vulnerabilities.

## 9. Event-Driven Security

- Restrict EventBridge publishing through least-privilege IAM policies.
- Restrict EventBridge-to-SQS delivery using queue resource policies.
- Scope allowed event sources to approved EventBridge rules.
- Give each consumer only the required SQS permissions.
- Encrypt event and queue data where required.
- Validate event schemas, event types, and source identities.
- Deduplicate events using stable event identities.
- Handle out-of-order and replayed events safely.
- Minimize sensitive information in event payloads.

## 10. Security Observability

- Use CloudTrail for AWS API auditing.
- Use CloudWatch for application logs, metrics, and alarms.
- Use AWS Config for configuration compliance evaluation.
- Aggregate supported security findings through AWS Security Hub.
- Use Amazon GuardDuty for supported threat detection.
- Preserve evidence and restrict access to security logs.

## 11. Open Design Decisions

- Final service-to-service authentication mechanism.
- AWS account and organizational security boundaries.
- KMS key ownership and management strategy.
- API rate limits and security alert thresholds.
- Approved data retention schedules.
- Incident-response ownership and escalation procedures.

## 12. Implementation and Validation

The controls in this document are design recommendations.

Implementation must be reviewed during subsequent AWS infrastructure,
Terraform, engineering, testing, and production-readiness phases.

Evidence of deployment, policy testing, and security validation must be
recorded separately before any control is considered operational.

# NorthStar Retail — Threat Model and Incident Response

## 1. Purpose and Status

Document proposed security threats, mitigations, and incident-response
procedures for the NorthStar Retail Enterprise Architecture.

Status: Proposed design. Security controls and response procedures
have not yet been deployed or exercised.

## 2. Architecture Scope

Components:
- Order Management System (OMS)
- Internal Application Load Balancer (ALB)
- ECS Fargate Inventory Reservation Service
- DynamoDB inventory, reservation, idempotency, and outbox records
- Outbox Publisher
- EventBridge and SQS consumers
- S3 data lake and analytics services
- IAM, KMS, Secrets Manager, CloudTrail, and security monitoring

## 3. Trust Boundaries

TB-01: OMS to Reservation API
- Authenticate the calling service.
- Authorize requested operations.
- Enforce TLS and input validation.

TB-02: Reservation Service to DynamoDB
- Use dedicated IAM task roles.
- Restrict table access.
- Enforce conditional transactions.

TB-03: Outbox Publisher to EventBridge
- Restrict events:PutEvents permissions.
- Validate published event contracts.

TB-04: EventBridge to SQS Consumers
- Restrict queue resource policies.
- Validate event sources and payloads.
- Handle duplicate and replayed events.

TB-05: Application and Analytics Data
- Apply data classification.
- Enforce IAM, KMS, and Lake Formation controls.
- Minimize sensitive information exposure.

## 4. STRIDE Threat Model

| ID | Category | Threat | Proposed Mitigation |
|---|---|---|---|
| THR-001 | Spoofing | Compromised OMS credentials | Strong authentication, short-lived credentials |
| THR-002 | Tampering | Unauthorized inventory event modification | IAM restrictions, schema validation, audit logging |
| THR-003 | Repudiation | Unauthorized reservation cancellation without evidence | Correlation IDs, audit trails, CloudTrail |
| THR-004 | Information Disclosure | Exposure of customer data in S3 | Block Public Access, IAM, KMS, monitoring |
| THR-005 | Denial of Service | Reservation API request flooding | Rate limiting, monitoring, capacity controls |
| THR-006 | Elevation of Privilege | Overly permissive ECS task role | Least privilege, policy reviews, guardrails |
| THR-007 | Tampering | Replay or duplicate reservation events | Idempotency, event identity, state validation |
| THR-008 | Information Disclosure | Credentials exposed in logs or code | Secrets Manager, log redaction, secret scanning |

## 5. Risk Assessment

Risk is evaluated using likelihood and business impact.

Illustrative priorities:

| Threat | Likelihood | Impact | Priority |
|---|---|---|---|
| Unauthorized reservation modification | Medium | High | High |
| Customer data exposure | Medium | Critical | Critical |
| Invalid inventory event | Medium | High | High |
| Compromised application credentials | Medium | High | High |

These ratings require validation with Security and business stakeholders.

## 6. Incident Response Lifecycle

### 6.1 Preparation
- Establish incident-response ownership and escalation contacts.
- Configure logging, alerting, and evidence retention.
- Define approved isolation and recovery procedures.
- Conduct incident-response exercises.

### 6.2 Detection and Analysis
- Review GuardDuty and Security Hub findings.
- Analyze CloudTrail and CloudWatch records.
- Correlate suspicious activity with reservation audit events.
- Determine affected identities, services, and data.

### 6.3 Containment
- Revoke or restrict compromised credentials.
- Apply targeted network or IAM restrictions.
- Isolate affected workloads when necessary.
- Preserve forensic evidence.
- Consider the effect of containment on legitimate orders.

### 6.4 Eradication
- Remove unauthorized access.
- Correct vulnerable configurations.
- Rotate affected secrets.
- Remediate exploited vulnerabilities.

### 6.5 Recovery
- Restore trusted application operations.
- Validate DynamoDB reservation and inventory integrity.
- Reconcile unauthorized or inconsistent reservations.
- Monitor for recurring suspicious activity.

### 6.6 Lessons Learned
- Conduct a post-incident review.
- Record root causes and control failures.
- Update architecture decisions and runbooks.
- Track remediation actions to completion.

## 7. Example Incident: Compromised OMS Identity

Scenario:
An attacker uses stolen OMS credentials to submit unauthorized
inventory reservation requests.

Proposed response:
1. Detect unusual reservation activity.
2. Confirm suspicious identity and request patterns.
3. Restrict the compromised identity.
4. Preserve CloudTrail and application audit evidence.
5. Identify affected reservations and inventory records.
6. Reconcile unauthorized transactions using approved procedures.
7. Restore access through trusted credentials.
8. Update controls and incident-response documentation.

## 8. AWS Security Services

| Service | Role |
|---|---|
| GuardDuty | Threat detection |
| Security Hub | Centralized security findings |
| CloudTrail | AWS API investigation |
| CloudWatch | Application monitoring |
| IAM | Identity containment |
| Secrets Manager | Credential rotation |
| EventBridge and Lambda | Approved response automation |

## 9. Incident Roles

- Security Operations: incident coordination and investigation.
- Platform Engineering: infrastructure containment and recovery.
- Application Engineering: application remediation.
- Data Owners: business data integrity verification.
- Solution Architect: architectural risk assessment and improvements.
- Legal and Privacy: assess applicable notification obligations.

## 10. Future Validation

- Conduct threat-model review workshops.
- Test compromised-credential response.
- Validate event replay and duplicate handling.
- Test evidence preservation and log access.
- Run incident-response tabletop exercises.
- Record results during testing and production-readiness phases.

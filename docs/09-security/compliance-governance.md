# NorthStar Retail — Compliance and Security Governance

## 1. Purpose and Status

Define proposed compliance, audit, data protection, and security
governance controls for the NorthStar Retail platform.

Status: Proposed architecture. No compliance certification or
production implementation is claimed.

## 2. Governance Principles

- Assign accountable owners to security and data controls.
- Apply least privilege and separation of duties.
- Classify data before selecting protection controls.
- Maintain evidence of security-relevant activities.
- Define approved retention and deletion schedules.
- Review exceptions and remediation activities.

## 3. Data Classification

| Classification | Example | Protection |
|---|---|---|
| Public | Product catalog | Approved public access |
| Internal | Inventory summaries | Authorized workforce and services |
| Confidential | Customer orders and addresses | Restricted access and encryption |
| Highly Restricted | Credentials and payment-sensitive data | Strict access, minimized storage |

Classification levels require approval from the organization's
security and data governance owners.

## 4. AWS CloudTrail and Audit Logging

- Configure centralized CloudTrail logging.
- Capture relevant management events.
- Enable S3 and DynamoDB data events where required.
- Protect audit storage using encryption and restricted access.
- Define retention and log integrity requirements.
- Monitor changes to IAM, KMS, networking, and security controls.
- Correlate AWS audit events with application-level reservation audits.

## 5. Continuous Compliance Monitoring

### AWS Config
- Evaluate approved configuration compliance rules.
- Detect noncompliant S3 public-access configurations.
- Monitor encryption and other supported configuration requirements.
- Route noncompliance findings to approved response workflows.

### AWS Security Hub
- Centralize supported security findings.
- Prioritize findings based on severity and business impact.
- Track investigation and remediation ownership.

### Amazon GuardDuty
- Detect supported suspicious activity and potential compromise.
- Escalate relevant findings to Security Operations.

## 6. Preventive Security Controls

- IAM least privilege and explicit-deny guardrails.
- AWS Organizations service control policies where applicable.
- S3 Block Public Access.
- Encryption and KMS authorization policies.
- Restrictive network security groups.
- Secure infrastructure-as-code review processes.

## 7. Data Retention and Deletion

Retention periods must be approved by Legal, Privacy, Security,
and the relevant business data owners.

Proposed implementation:
- S3 Lifecycle policies for eligible object expiration.
- S3 Object Lock for records requiring immutability.
- Defined application and CloudWatch log retention.
- Approved deletion workflows for customer-related data.
- Legal-hold exceptions and documented deletion evidence.

No universal retention period is assumed.

## 8. Data Lake Governance

- Use AWS Lake Formation for supported fine-grained data access.
- Apply IAM and KMS controls to S3 and analytics services.
- Restrict sensitive customer attributes.
- Review access to Glue Data Catalog and Athena workgroups.
- Record data ownership and permitted analytical uses.

## 9. Compliance Considerations

### PCI DSS
Assess applicability to payment-processing systems and connected
components. Minimize cardholder data exposure and define scope.

### Privacy
Identify applicable privacy requirements based on jurisdiction,
customer data, processing purposes, and business obligations.

### Internal Policies
Define security baselines, access reviews, exception management,
audit evidence, and control ownership.

AWS service adoption does not automatically establish compliance.

## 10. Governance Ownership

| Role | Responsibility |
|---|---|
| Security Architecture | Security design and control standards |
| Security Operations | Monitoring and incident investigation |
| Platform Engineering | Infrastructure control implementation |
| Application Engineering | Secure application and API controls |
| Data Governance | Classification and retention requirements |
| Legal and Privacy | Regulatory and contractual interpretation |
| Business Owners | Data ownership and business risk acceptance |

## 11. Control Validation

Future implementation phases must produce evidence for:
- IAM and resource policy reviews.
- Encryption and key access testing.
- CloudTrail and compliance monitoring configuration.
- Data retention and deletion tests.
- Security finding escalation.
- Governance approvals and documented exceptions.

## 12. Open Decisions

- Approved classification taxonomy.
- Applicable regulatory obligations.
- Retention periods by data category.
- Organization-wide audit logging strategy.
- Security finding escalation thresholds.
- Governance review frequency.

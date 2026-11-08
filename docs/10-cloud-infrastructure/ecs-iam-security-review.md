# NorthStar Retail — ECS IAM Security Review

## Scope
Reservation Service running on AWS ECS Fargate.

## Existing Controls
- Separate ECS execution and application task IAM roles.
- AWS-managed ECS task execution policy.
- DynamoDB permissions scoped to configured table ARNs and indexes.
- Internal Application Load Balancer.
- ECS inbound traffic restricted to the ALB security group.
- Application container configured for non-root execution.
- Read-only container root filesystem.

## IAM Review Findings

### ECS Execution Role
Review whether the AWS-managed execution policy is sufficient.
Additional permissions must be justified by runtime requirements.

### ECS Task Role
Review DynamoDB GetItem, PutItem, UpdateItem, Query,
and TransactWriteItems permissions against application access patterns.

### Future Integrations
EventBridge and SQS permissions must be added only when required,
using specific resources and actions wherever supported.

## Open Security Risks
- ECS outbound HTTPS currently permits destinations across 0.0.0.0/0.
- End-to-end TLS between ALB and ECS is not implemented.
- IAM permissions have not been tested against running application behavior.
- Container image permissions and runtime behavior remain unverified.

## Production Acceptance Criteria
- Validate IAM permissions against actual application operations.
- Confirm least-privilege access.
- Review network egress restrictions.
- Verify encryption requirements.
- Perform container image scanning and runtime security tests.
- Complete architecture and security approval.

## Status
Design review only. No AWS resources deployed.

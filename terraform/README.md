# NorthStar Retail Terraform — Phase 9 implementation

## Included
- Networking: VPC, public/private subnets, 2 NAT gateways, S3/DynamoDB gateway endpoints; optional ECR API, ECR Docker and CloudWatch Logs interface endpoints.
- Security: internal ALB/ECS security groups and separate IAM execution/task roles.
- ECS: private Fargate reservation service, internal HTTPS ALB, health checks, CloudWatch logging, CPU autoscaling.
- DynamoDB: inventory, reservations, outbox tables (PAY_PER_REQUEST, PITR, encryption at rest).
- EventBridge: custom event bus, inventory event rule, three SQS consumer queues with DLQs.
- dev/staging/prod: separate root modules and illustrative capacity settings.

## Important limitations / pre-deployment work
- **Do not apply yet.** This is a Terraform design scaffold, not a production-ready deployment.
- An existing ACM certificate, deployable container image and AWS credentials are required for plans/deployment. The container must run on port 8080, serve GET /health, support UID/GID 10001 and a read-only root filesystem.
- No ECR repository or application container image is created. No running consumers, outbox publisher, or event publication permissions are implemented; messaging infrastructure is only provisioned.
- Egress TCP/443 remains broad pending dependency-specific review. NAT gateways remain configured even when interface endpoints are enabled. Private interface endpoints incur hourly/data charges. Evaluate NAT vs endpoint costs.
- IAM DynamoDB actions and GSI ARNs need review against real access patterns. Data schema and access patterns are illustrative and must be designed/tested before production.
- ALB-to-ECS target traffic is HTTP inside the VPC, not end-to-end TLS. ALB ingress is VPC CIDR only.
- DynamoDB table design uses pk/sk for all tables; real inventory contention, idempotency and outbox semantics are NOT implemented by Terraform.
- For production, configure remote encrypted state and locking, separate AWS accounts, policy scanning, CI validation, access logging, monitoring, alarms, quotas and cost controls. No backend is configured deliberately.
- Existing ALB naming/length and service resource quotas must be checked in a real plan.

## Validate locally, without AWS deployment
From repository root:

```bash
terraform fmt -recursive terraform
for module in networking security ecs dynamodb eventbridge; do
  terraform -chdir="terraform/modules/$module" init -backend=false
  terraform -chdir="terraform/modules/$module" validate || exit 1
done
for env in dev staging prod; do
  terraform -chdir="terraform/environments/$env" init -backend=false
  terraform -chdir="terraform/environments/$env" validate || exit 1
done
```

`init` may download providers/modules. `validate` checks configuration structure; it does **not** confirm deployability, IAM sufficiency, costs, app behavior, or AWS quotas. No `plan`/`apply` is run.

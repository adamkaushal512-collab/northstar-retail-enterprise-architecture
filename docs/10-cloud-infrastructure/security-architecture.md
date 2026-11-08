# NorthStar Retail — AWS Security Architecture

## 1. Security Objectives

- Apply least-privilege access.
- Protect application and customer data.
- Restrict network access between services.
- Encrypt data in transit and at rest.
- Maintain auditable infrastructure configurations.
- Avoid unnecessary infrastructure cost.

## 2. Network Security

- ECS Fargate workloads run in private subnets.
- The Application Load Balancer is internal.
- ALB inbound access uses TCP port 443.
- ALB outbound application traffic is restricted to the ECS security group.
- ECS application ingress is restricted to the ALB security group.
- ECS outbound HTTPS is currently permitted to all IPv4 destinations.
- DynamoDB and S3 Gateway VPC Endpoints provide private AWS service access.

## 3. Identity and Access Management

### ECS Execution Role
- Trusted by ecs-tasks.amazonaws.com.
- Uses AmazonECSTaskExecutionRolePolicy.
- Supports container image retrieval and CloudWatch logging.

### ECS Application Task Role
- Separate from the execution role.
- Grants selected DynamoDB actions.
- Restricts access to explicitly supplied table ARNs and indexes.
- Does not grant DynamoDB administrative permissions.

## 4. Encryption

### In Transit
- Internal ALB will use HTTPS with an ACM certificate.
- ALB-to-ECS traffic currently uses HTTP on the application port.
- Backend TLS requirements must be evaluated before production.

### At Rest
- DynamoDB encryption configuration will be implemented in the DynamoDB module.
- CloudWatch Logs encryption and retention will be reviewed in the ECS module.
- S3 encryption and bucket security will be addressed in the storage architecture.

## 5. Remaining Production Controls

- Configure and validate the ALB HTTPS listener and certificate.
- Narrow ALB ingress to approved client networks or security groups.
- Evaluate backend TLS requirements.
- Review ECS egress restrictions and VPC interface endpoints.
- Implement encryption and key-management requirements.
- Configure logging, monitoring, and audit trails.
- Review IAM policies against actual application operations.
- Add automated Terraform security scanning.
- Validate integrated infrastructure configuration.
- Perform deployment readiness and cost reviews.

## 6. Deployment Status

Architecture and Terraform configuration only.
No AWS infrastructure has been deployed.

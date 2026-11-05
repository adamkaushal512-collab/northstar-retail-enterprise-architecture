# ADR-001: Compute Platform Selection

## Status
Proposed

## Context
NorthStar Retail requires a reliable, scalable compute platform
for its Inventory Reservation Service.

The service must:
- Process synchronous REST API requests.
- Support high concurrency during peak shopping periods.
- Run across multiple Availability Zones.
- Scale based on workload demand.
- Minimize infrastructure administration.
- Support containerized application deployment.

## Options Considered

### Option 1: AWS Lambda
Advantages:
- Serverless execution.
- Automatic concurrency scaling.
- Usage-based pricing.

Tradeoffs:
- Execution duration limits.
- Cold-start considerations.
- Different operational model for continuously running APIs.

### Option 2: Amazon ECS with AWS Fargate
Advantages:
- Managed container orchestration.
- No EC2 server management.
- Supports continuously running REST APIs.
- Integrates with ALB and Service Auto Scaling.
- Supports multi-AZ deployments.

Tradeoffs:
- Ongoing task compute costs.
- Requires container deployment and capacity management.
- Scaling is not instantaneous.

### Option 3: Amazon EKS
Advantages:
- Kubernetes ecosystem.
- Advanced workload orchestration.
- Portability of Kubernetes deployment patterns.

Tradeoffs:
- Greater operational complexity.
- Additional Kubernetes expertise required.
- More platform components to maintain.

## Proposed Decision
Use Amazon ECS with AWS Fargate.

Deploy the Inventory Reservation Service as stateless
containers behind an internal Application Load Balancer.

Distribute ECS tasks across multiple Availability Zones.

Configure health checks, autoscaling, monitoring,
and deployment rollback capabilities.

## Rationale
ECS Fargate meets the current containerized API requirements
without introducing unnecessary Kubernetes complexity.

## Consequences
Positive:
- Reduced infrastructure management.
- Straightforward container deployment.
- Multi-AZ availability and managed scaling.

Negative:
- Continuous compute costs.
- Scaling delays during sudden demand spikes.
- Application-level resilience remains necessary.

## Risks and Mitigations
- Traffic spikes: maintain baseline capacity and load-test.
- AZ failure: distribute tasks across multiple AZs.
- Database bottlenecks: independently test DynamoDB throughput.
- Failed deployments: implement health checks and rollback.

## Validation Criteria
- Demonstrate successful multi-AZ failover.
- Validate API latency at expected peak load.
- Measure autoscaling response times.
- Estimate monthly and peak-event compute costs.
- Verify deployment rollback procedures.

## Related Decisions
- ADR-002: Reservation Database
- ADR-003: Event Messaging
- ADR-004: API Integration

## Approval
Pending architecture review.

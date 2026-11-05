# ADR-004: API Integration Technology Selection

## Status
Proposed

## Context
NorthStar Retail requires secure, reliable communication
between the Order Management System (OMS) and the
Inventory Reservation Service.

The OMS needs an immediate, authoritative response when
attempting to reserve inventory.

Requirements:
- Synchronous HTTPS REST API.
- Private enterprise network access.
- Authentication and authorization.
- Low-latency request processing.
- Multi-AZ availability.
- Load balancing across ECS tasks.
- Health checks and failure detection.
- Request tracing and observability.
- Safe retries and idempotency.

## Options Considered

### Option 1: Amazon API Gateway

Advantages:
- Managed API front door.
- Authentication and authorization integrations.
- Throttling and API management capabilities.
- API monitoring and governance features.

Tradeoffs:
- Additional request-based costs.
- Service quotas and integration constraints.
- Additional components for private ECS integrations.

### Option 2: Internal Application Load Balancer

Advantages:
- Native integration with ECS services.
- HTTP and HTTPS routing.
- Target-group health checks.
- Multi-AZ traffic distribution.
- Private network exposure.
- Supports long-running containerized REST APIs.

Tradeoffs:
- Limited built-in API management compared with API Gateway.
- Application-level authentication may be required.
- API quotas and consumer governance require additional design.

### Option 3: Direct ECS Task Connectivity

Advantages:
- Fewer intermediary components.
- Potentially simpler for tightly controlled environments.

Tradeoffs:
- Dynamic task addresses complicate discovery.
- Additional responsibility for traffic distribution.
- Health-based routing requires another mechanism.
- Not preferred for this integration.

## Proposed Decision
Use an internal Application Load Balancer to expose
the Inventory Reservation Service within private
AWS networking.

Deploy the service on Amazon ECS with AWS Fargate.

Use HTTPS for communication between the OMS and ALB.

Use appropriate encryption for ALB-to-task traffic
based on the approved security design.

Implement service authentication and authorization.

Restrict network access using security groups and
approved routing boundaries.

## Proposed Request Flow

Order Management System
    |
    | HTTPS REST request
    v
Internal Application Load Balancer
    |
    v
Inventory Reservation Service
(ECS with AWS Fargate)
    |
    v
Amazon DynamoDB
    |
    v
Reservation Result Returned to OMS

## API Design Principles

- Use resource-oriented REST endpoints.
- Define contracts using OpenAPI.
- Validate request payloads.
- Use stable idempotency keys.
- Return consistent error responses.
- Apply appropriate request timeouts.
- Retry only when safe.
- Propagate correlation identifiers.
- Avoid exposing internal implementation details.

Detailed API contracts will be created in Phase 6.

## Security

- Keep the ALB internal.
- Use TLS for client connections.
- Authenticate service callers.
- Authorize permitted operations.
- Apply least-privilege IAM where applicable.
- Restrict security-group ingress and egress.
- Manage credentials and certificates securely.
- Log security-relevant activity.

Private networking alone is not sufficient authentication.

## Reliability

- Distribute ECS tasks across multiple AZs.
- Configure ALB target-group health checks.
- Maintain sufficient baseline task capacity.
- Configure ECS Service Auto Scaling.
- Implement safe retry and timeout policies.
- Test task and AZ failure scenarios.

## Observability

Monitor:
- ALB request counts.
- HTTP 4xx and 5xx responses.
- Target response latency.
- Healthy and unhealthy target counts.
- Reservation API error rates.
- End-to-end request traces.
- Authentication and authorization failures.

## Consequences

Positive:
- Straightforward ECS integration.
- Private API exposure.
- Managed load balancing.
- Multi-AZ routing and health checks.

Negative:
- Less built-in API governance than API Gateway.
- Additional application security responsibilities.
- Future external consumers may require an API gateway.

## Validation Criteria

- Verify only authorized callers can access the API.
- Test TLS and network restrictions.
- Validate load balancing across ECS tasks.
- Test unhealthy task removal.
- Measure p95 and p99 API latency.
- Verify idempotent retry behavior.
- Test an AZ failure.
- Evaluate normal and peak operating costs.

## Related Decisions
- ADR-001: Compute Platform
- ADR-002: Reservation Database
- ADR-003: Event Messaging

## Approval
Pending architecture review.

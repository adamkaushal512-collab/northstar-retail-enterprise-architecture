# ADR-003: Event Messaging Architecture

## Status
Proposed

## Context
NorthStar Retail requires reliable asynchronous communication
between its inventory, order, fulfillment, and analytics systems.

When an inventory reservation succeeds, multiple downstream
systems must receive the corresponding business event.

Consumers include:
- Online Inventory View
- Store Fulfillment
- Analytics

Business requirements:
- Independent consumer processing.
- Failure isolation.
- Durable event buffering.
- Reliable event publication.
- Duplicate-safe processing.
- Monitoring and failure recovery.
- Support for future event consumers.

## Options Considered

### Option 1: Amazon EventBridge

Advantages:
- Managed event routing.
- Content-based filtering.
- Loose coupling between publishers and consumers.
- Integration with AWS services.

Tradeoffs:
- At-least-once delivery behavior.
- Ordering is not guaranteed.
- Durable consumer buffering requires suitable targets.
- Event size, throughput, and cost limits apply.

### Option 2: Amazon SNS with Amazon SQS

Advantages:
- Fan-out messaging.
- Durable consumer queues.
- Independent retry and failure handling.
- Managed AWS services.

Tradeoffs:
- Additional subscription and filtering configuration.
- Standard queues may deliver duplicate messages.
- Strict ordering requires additional design.

### Option 3: Amazon MSK

Advantages:
- Managed Apache Kafka.
- Retained event streams.
- Consumer-controlled replay.
- Partitioned event processing.

Tradeoffs:
- Greater operational complexity.
- Requires Kafka expertise.
- Additional capacity and cost management.

## Proposed Decision
Use Amazon EventBridge for business event routing.

Use a dedicated Amazon SQS queue for each independent
downstream consumer.

Configure dead-letter queues and monitoring for failed
event processing.

## Proposed Event Flow

Inventory Reservation Service
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

## Reliable Event Publication

A successful inventory reservation must not lose its
business event if the application crashes after committing
the database transaction.

Use a durable event-publication mechanism, such as an
outbox design backed by DynamoDB Streams, with appropriate
failure recovery and replay procedures.

Publishing to EventBridge must be retried safely.

A successful database commit does not imply immediate
delivery to every downstream consumer.

## Event Contract

Each event should contain:
- eventId
- eventType
- eventVersion
- occurredAt
- reservationId
- orderId
- storeId
- sku
- quantity
- correlationId

Detailed event schemas will be designed in Phase 6.

## Delivery Semantics

Assume at-least-once event delivery.

Consumers must be idempotent.

Use stable event identifiers to detect duplicate deliveries.

Standard SQS queues do not guarantee strict message ordering.

Where ordering is required, evaluate sequence numbers,
entity versions, or an appropriate ordered-processing design.

## Failure Handling

### Consumer Failure
Messages remain in the consumer queue until successfully
processed, expired, or moved to a dead-letter queue.

### Duplicate Delivery
Consumers detect previously processed event identities
and avoid duplicate business effects.

### Poison Messages
Configure bounded retries and dead-letter queues.

### Publisher Failure
Retry event publication from durable state.

### Downstream Outage
Other consumers continue operating independently.

## Observability

Monitor:
- Event publication failures.
- EventBridge delivery failures.
- SQS queue depth.
- Age of oldest message.
- Dead-letter queue counts.
- Consumer processing latency.
- Duplicate event detection.
- End-to-end event propagation latency.

## Consequences

Positive:
- Loose coupling.
- Independent consumer scaling.
- Failure isolation.
- Managed event routing and buffering.
- Easier addition of future consumers.

Negative:
- Eventual consistency.
- Duplicate processing risk.
- Additional queues and operational monitoring.
- More complex end-to-end troubleshooting.

## Validation Criteria

- Verify all intended consumers receive events.
- Test duplicate event delivery.
- Test consumer outages and recovery.
- Test dead-letter queue behavior.
- Verify publisher crash recovery.
- Measure end-to-end propagation latency.
- Validate event routing and filtering.
- Estimate messaging costs under peak traffic.

## Related Decisions
- ADR-001: Compute Platform
- ADR-002: Reservation Database
- ADR-004: API Integration

## Approval
Pending architecture review.

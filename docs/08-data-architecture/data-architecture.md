# NorthStar Retail — Enterprise Data Architecture

**Phase:** 7 — Data Architecture & Event-Driven Systems
**Status:** Proposed architecture — pending stakeholder and engineering review

## 1. Purpose

Define how NorthStar Retail owns, stores, processes, distributes,
protects, and analyzes enterprise data across its omnichannel
commerce platform.

The architecture supports approximately 500 retail stores and
must prioritize inventory correctness, scalability, reliability,
auditability, and analytical capabilities.

## 2. Architecture Principles

1. Establish clear ownership for every business data entity.
2. Keep inventory reservation decisions authoritative.
3. Separate transactional and analytical workloads.
4. Use atomic operations for correctness-critical changes.
5. Design event consumers for duplicate and out-of-order delivery.
6. Preserve raw analytical data for controlled reprocessing.
7. Apply least-privilege access and approved retention policies.
8. Measure data quality, freshness, and lineage.

## 3. Enterprise Data Ownership

| Data Entity | Authoritative System |
|---|---|
| Customer orders | Order Management System (OMS) |
| Inventory reservations | Inventory Reservation Service |
| Store sales transactions | Point of Sale (POS) |
| Warehouse stock movements | Warehouse Management System (WMS) |
| Customer profiles | Customer/Loyalty Platform |
| Analytical reporting datasets | Analytics Platform |

Inventory availability must be coordinated through the inventory
domain's authoritative business rules.

OMS, POS, WMS, and Analytics must not independently overwrite
authoritative reservation records.

## 4. Operational Data Architecture

The proposed Inventory Reservation Service runs on Amazon ECS
with AWS Fargate and uses Amazon DynamoDB.

DynamoDB stores:

- Inventory availability records
- Reservation records
- Idempotency records
- Durable outbox records

Conditional writes and TransactWriteItems protect concurrent
reservation operations.

The complete reservation transaction must coordinate inventory
updates, reservation creation, idempotency, and outbox intent.

A successful transaction commits all required changes atomically.

## 5. Consistency Model

Strong correctness is required for authoritative inventory
reservation decisions.

DynamoDB conditional writes or transactions enforce inventory
constraints atomically.

Online Inventory View, Fulfillment, and Analytics are downstream
consumers and may be eventually consistent.

Replicated inventory views must not authorize reservations.

## 6. Event-Driven Data Architecture

The Reservation Service records publication intent through a
durable outbox mechanism.

A reliable publisher sends committed business events to
Amazon EventBridge.

EventBridge distributes events through independent Amazon SQS
queues to:

- Online Inventory View
- Store Fulfillment
- Analytics ingestion

Consumers must support:

- At-least-once delivery
- Durable idempotency
- Duplicate detection
- Out-of-order event handling
- Retry policies and dead-letter queues
- Schema compatibility and versioning

## 7. Analytical Data Architecture

The proposed analytical pipeline is:

Reservation Events
    -> EventBridge
    -> Analytics SQS
    -> Ingestion Consumer
    -> Amazon S3
    -> AWS Glue
    -> AWS Glue Data Catalog
    -> Amazon Athena
    -> Business Intelligence

This is a logical design. The ingestion consumer, transformations,
catalog integration, and monitoring must be implemented and tested.

Historical analytics should not depend on repeated full scans of
the operational reservation database.

## 8. Data Lake Organization

The proposed S3 data lake uses three logical layers.

### Bronze

Raw source events retained according to approved policies.

### Silver

Validated, normalized, and deduplicated analytical records.

### Gold

Business-ready datasets and aggregates, such as daily
reservation totals by store, SKU, and channel.

Example S3 prefix:

s3://northstar-retail-data/bronze/inventory-events/year=2026/month=11/day=05/

The bucket name is illustrative, not a deployed resource.

## 9. Data Quality

Data quality checks include:

- Required-field completeness
- Schema and type validation
- Positive reservation quantities
- Valid business identifiers
- Event identity deduplication
- Timestamp validity
- Data freshness
- Reconciliation with authoritative sources

Invalid records should be quarantined or routed for investigation.

## 10. Data Lineage

Data lineage should trace analytical metrics from:

Source Service
    -> Business Event
    -> Ingestion
    -> Raw S3 Dataset
    -> Glue Transformation
    -> Curated Dataset
    -> Athena Query
    -> Dashboard

Dataset owners must document transformation logic and business
metric definitions.

## 11. Security and Governance

Proposed controls include:

- Least-privilege IAM policies
- AWS Lake Formation permissions where applicable
- Encryption using AWS KMS
- S3 Block Public Access
- Appropriate network and endpoint controls
- Access and activity auditing
- Sensitive-data classification and masking
- Approved data retention and deletion policies

Retention periods require business, legal, and compliance approval.

## 12. Observability

Monitor:

- Event ingestion lag
- Consumer failures
- SQS backlog and DLQ depth
- Duplicate and invalid event rates
- Data pipeline execution failures
- Data freshness
- Transformation success rates
- Athena query cost and performance
- DynamoDB throttling and transaction conflicts

## 13. Architecture Alignment

This design builds on previously proposed decisions:

- ADR-001: ECS with AWS Fargate
- ADR-002: Amazon DynamoDB
- ADR-003: Amazon EventBridge and SQS
- ADR-004: Internal ALB and REST API

The design is not evidence of deployed or approved infrastructure.

## 14. Open Architecture Questions

- Final inventory availability ownership boundaries
- DynamoDB table and index design
- Hot-key mitigation and contention limits
- Outbox publisher implementation
- Aggregate versioning and event ordering
- Data lake ingestion and replay strategy
- Dataset retention and privacy requirements
- Data quality thresholds and ownership
- Data lineage tooling
- Disaster recovery and cross-region requirements

## 15. Related Phase 7 Artifacts

- dynamodb-data-model.md
- event-data-contracts.md
- ../../diagrams/data-architecture.mmd

## 16. Next Phase

Phase 8 — Security, Compliance & Governance.

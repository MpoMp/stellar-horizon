# ADR 2: Services Architecture

## Status
Accepted

## Context
We need to define the core services that will make up the trading platform and their respective responsibilities and 
communication patterns.

## Decision
We will implement three core services using the latest version of Quarkus:

1.  **Order Gateway**
    - Exposes an HTTP JSON API for accepting new buy and sell orders.
    - Persists each order to a database with a `PENDING` status.
    - Publishes a message to RabbitMQ to notify other services of the new order.

2.  **Matching Engine**
    - Consumes order messages from RabbitMQ.
    - Processes orders and updates their status in the database to `COMPLETED` if fulfilled successfully.

3.  **Backofficer**
    - Serves as an administrative interface.
    - Allows its (authenticated) users to browse and handle orders.

## Consequences
- Clear separation of concerns between order ingestion, processing, and management.
- Asynchronous communication via RabbitMQ allows for better scalability and decoupling.
- Standardized tech stack (Quarkus) across all services simplifies development and deployment.
- Everything under one repository since we're not in an enterprise environment.
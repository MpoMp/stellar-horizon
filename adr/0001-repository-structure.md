# ADR 1: Repository Structure

## Status
Accepted

## Context
The project needs a clear and documented directory structure to ensure consistency as it grows. 

## Decision
We will organise the repository using the following structure:

- `adr/`: Contains Architectural Decision Records (ADRs) to document key technical decisions.
- Each sub-project to follow will exist in its own root directory. 
  - For example, each Quarkus application, the Postgres database, and the RabbitMQ broker will be in their own sub-directory.

## Consequences
- Any contributor will have a clear place to look for architectural decisions.
- The project structure remains organised and scalable. 
- AI agents can leverage the ADRs to understand the project's architecture.

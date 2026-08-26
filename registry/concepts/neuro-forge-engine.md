# Internal Execution Engine

Status: Internal-only concept; public product name unresolved  
Naming authority: [`registry/decisions.md`](../decisions.md), Decision 005

## Definition

The internal execution engine performs bounded automation, validation, build preparation, routing, and orchestration within DrMarchand’s Laboratory and delegated permission.

It is not a public Design Orchard service provider, public checkout surface, separate legal authority, or self-authorizing actor.

## Compatibility identifiers

Existing strings such as `NFE`, repository names, database names, commands, schemas, routes, and file paths are machine identifiers. Preserve them exactly where compatibility requires them.

Do not expand or promote those identifiers as a public product or brand name. The former public naming decision is superseded for active public use and remains available in Git history and the decision ledger as provenance.

## Functional scope

The internal execution engine may support:

- automation;
- validation;
- build and compilation preparation;
- documentation preparation;
- connection-interface preparation;
- runtime-definition preparation;
- infrastructure orchestration within permission.

## Boundary

External platforms cross explicit connection interfaces. The engine does not acquire authority by calling them, and they do not become internal components merely because the engine invokes, validates, or monitors a connection.

# Bridges

Status: Canonical concept
Registry path: `registry/concepts/bridges.md`
System: DrMarchand-OS™

---

## Definition

Bridges are controlled interfaces between DrMarchand's Lab⚛︎ratory™ systems and external platforms, services, APIs, connectors, or integrations.

A bridge translates. It does not own or define the internal system.

---

## Bridge Boundary

External services, platforms, APIs, connectors, and integrations are not part of the engine directly.

All third-party integrations must be treated as bridge interfaces. A bridge translates between internal systems and external systems while preserving internal authority boundaries.

---

## Role

Bridges support:

- external platform connection
- connector translation
- import/export flow
- interface contracts
- boundary enforcement
- system protection from external authority confusion

---

## Rule

External systems must not be represented as owning or defining:

- Registry meaning
- internal authority
- runtime identity
- Atlas structure
- DrMarchand's ⚙︎ Nɛuro-Forge Engine™ behavior

---

## Boundary

A bridge may connect to an external system, but it does not make that external system part of the internal engine.

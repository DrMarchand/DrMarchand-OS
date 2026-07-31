# DrMarchand’s ∞ OS™ — Core Architecture

**Status:** Current architecture record  
**Audience:** Public and cross-system  
**Legal authority:** Design Orchard LLC  
**Operational context:** 🔬 DrMarchand’s Lab⚛︎ratory™

## Repository responsibility

`DrMarchand/DrMarchand-OS` preserves versioned architecture, presentation-layer definitions, registry documentation, and Atlas-oriented SQL artifacts for DrMarchand’s ∞ OS™.

This repository is not:

- the legal authority;
- DrMarchand’s ⚙︎ Nɛuro-Forge Engine™;
- 🗺️ DrMarchand’s ⚛︎ Atlas itself;
- proof that a runtime is deployed or healthy;
- the permanent institutional record.

## Responsibility model

| Surface | May do | Must not be treated as |
|---|---|---|
| `Design Orchard LLC` and authorized human | Delegate, approve, reject, and validate final state | An automated or optional gate |
| `🔬 DrMarchand’s Lab⚛︎ratory™` | Supply delegated operating context | A separate legal authority |
| `DrMarchand’s ⚙︎ Nɛuro-Forge Engine™` | Execute and validate within bounded permission | Independently sovereign or self-authorizing |
| `🗺️ DrMarchand’s ⚛︎ Atlas` | Register objects and resolve relationships and truth states | Legal ownership or organizational authority |
| `DrMarchand’s ∞ OS™` | Present, navigate, and route interaction | The execution runtime or truth resolver |
| `📚 DrMarchand’s ⚛︎ Library™` | Preserve approved records and institutional memory | Temporary working memory |

## Repository surfaces

| Surface | Responsibility |
|---|---|
| [`registry/`](.) | Versioned architecture and relationship documentation |
| [`../docs/canon/ecosystem-map.md`](../docs/canon/ecosystem-map.md) | Namespace and system placement |
| [`../schemas/mysql/neuro_forge_engine/2026_07_05_atlas_runtime_seed.sql`](../schemas/mysql/neuro_forge_engine/2026_07_05_atlas_runtime_seed.sql) | Database schema and seed definitions using compatibility machine identifiers |

## Truth and evidence

- 🗺️ DrMarchand’s ⚛︎ Atlas resolves registered object identity, relationships, bindings, and truth states.
- GitHub preserves versioned engineering artifacts and their change history.
- A database row proves recorded state only; it does not prove current external-system health.
- 📚 DrMarchand’s ⚛︎ Library™ is the permanent custody destination for approved institutional records.
- An authorized human performs final validation.

## Bridge boundary

Every external crossing must identify its source, target, direction, payload, requesting authority, execution permission, validation, failure behavior, receipt, and custody destination.

Bridges remain external interfaces even when DrMarchand’s ⚙︎ Nɛuro-Forge Engine™ invokes or validates them. A Bridge does not own an internal system or carry authority across the boundary.

## Compatibility boundary

Repository paths, database names such as `Neuro-Forge_Engine`, node keys, route names, package names, and environment variables are machine identifiers. Preserve them until an evidenced migration identifies consumers, rollback behavior, and validation.

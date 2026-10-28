# OS Repository Architecture

Status: owner-corrected engineering/design record, 2026-10-28. Repository coordinate: `DrMarchand/DrMarchand-OS`. Legal company: Design Orchard LLC.

## OS scope

**DrMarchand’s OS™** is the private Laboratory-linked OS, discussed publicly for release/beta announcements. **Design Orchard OS™** is the public OS and base of the company and all its DBAs.

The separate Engine-specific bridge sandbox uses **♾️ OS** for the private root and **∞ OS** for the public build. Preserve the exact owner pattern: **♾️ OS → ∞ OS → ⚙︎ Nɛuro-Forge Engine™ → ⚙︎ Nɛuro-Forge Engine**. Outside the system use **DrMarchand’s ⚙︎ Nɛuro-Forge Engine**.

## Context, authority and evidence

The [company system contract](https://github.com/DrMarchand/DesignOrchard.LLC/blob/main/SYSTEM_CONTRACT.md) defines current roles. The Engine executes only within delegated permission; a view, registry, symbol, task or bridge does not grant itself authority. The Laboratory supplies delegated working context. 📚 DrMarchand’s ⚛︎ Library™ preserves approved records.

## Engineering records

Use [decisions.md](decisions.md), [glossary.md](glossary.md) and [concept records](concepts/) for versioned engineering memory. Earlier conflicting definitions are pending reconciliation or explicitly historical; current owner corrections take precedence. Preserve real identifiers, provenance and Git history. Do not claim a registry has been updated merely because its documentation changed.

## Bridges and public boundary

External providers remain external. Bridge interfaces specify source/target, payload, requested effect, permission, validation, failure and receipt. Keep private-root contents, credentials, private coordinates and restricted working data outside public source. Repository documentation is not evidence of deployed access isolation, runtime operation, physics accuracy or promotion.

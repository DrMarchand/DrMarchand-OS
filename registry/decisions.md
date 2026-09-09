# Registry Decisions

Status: Canonical ledger
Registry path: `registry/decisions.md`
System: DrMarchand’s OS™

---

## Purpose

This file records architectural decisions so concepts do not need to be re-argued or redefined in every document.

Decisions should be appended, not silently rewritten, unless a later decision explicitly supersedes an earlier one.

---

## Decision 001 — Registry is the source of truth for meaning

**Decision:** The Registry is the canonical source of truth for system meaning inside the `DrMarchand/DrMarchand-OS` repository.

**Reason:** README files, license text, code, bridge documents, and future runtime interfaces should reference stable institutional memory instead of redefining concepts independently.

**Status:** Adopted; scope clarified by Decision 007.

---

## Decision 002 — External systems are bridges

**Decision:** External platforms, APIs, connectors, and integrations are treated as bridge interfaces.

**Reason:** External systems may connect to 🔬 DrMarchand’s Lab⚛︎ratory™ systems, but they must not own or define internal authority, Registry meaning, runtime identity, or Atlas structure.

**Status:** Adopted.

---

## Decision 003 — Canonical Engine naming

**Decision:** The canonical cross-system phrasing is `DrMarchand’s ⚙︎ Nɛuro-Forge Engine™`.

**Reason:** The Engine identity must remain tied to DrMarchand’s system context and preserve the canonical `ɛ` spelling.

**Status:** Adopted; operational boundary clarified by Decision 006.

---

## Decision 004 — Workbench is not generic

**Decision:** There is no single generic Workbench.

**Reason:** The Library Workbench and Laboratory Workbench perform different functions and must remain distinct.

**Status:** Adopted.

---

## Decision 005 — Current OS identity and infinity bridge

**Decision:** The current published system identity is `DrMarchand’s OS™`. `Infinity OS` and `Infinite OS` are superseded aliases and must not be used as current product identities.

**Decision:** The `∞` symbol represents an infinite-bridge concept inside DrMarchand’s OS™. It does not expand to an alternate English product name.

**Reason:** Identity and architectural notation must remain separate so localization, AI interpretation, or historical folder names cannot silently rename the system.

**Status:** Adopted 2026-09-09 by authorized-human instruction.

---

## Decision 006 — OS and Engine remain separate

**Decision:** DrMarchand’s OS™ is the presentation, navigation, routing, and lifecycle-state layer. DrMarchand’s ⚙︎ Nɛuro-Forge Engine™ is the bounded execution and orchestration system.

**Reason:** Displaying Engine state does not make the Engine a component owned by the OS, and executing work does not make the Engine the presentation system.

**Status:** Adopted 2026-09-09 by authorized-human instruction.

---

## Decision 007 — Active display policy is server-resolved

**Decision:** The private server identity registry resolves active display-name and mark policy. The GitHub Registry remains versioned engineering memory and may receive a release-safe mirror; GitHub does not independently redefine active private identity policy.

**Reason:** Stable IDs, display variants, legal identity, runtime state, and public documentation have different authority scopes. A string committed to GitHub must not override the active private registry by accident.

**Status:** Adopted 2026-09-09; this clarifies Decision 001 rather than deleting it.

---

## Decision 008 — Local production markers stay local

**Decision:** Private local-production markers and device-specific production identities do not belong in public GitHub and should not be mirrored into GitHub merely because a repository is private.

**Reason:** Local production notation is a security and context boundary, not a portable product identity.

**Status:** Adopted 2026-09-09 by authorized-human instruction.

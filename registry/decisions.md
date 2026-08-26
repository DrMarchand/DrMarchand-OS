# Registry Decisions

Status: Canonical decision ledger  
Registry path: `registry/decisions.md`  
System: `DrMarchand-OS`

## Purpose

This file records architectural and naming decisions. New decisions supersede earlier decisions explicitly; history is not silently rewritten.

## Decision 001 — Registry is the source of truth for meaning

**Decision:** The Registry is the canonical source of meaning inside `DrMarchand-OS`.

**Reason:** README files, license text, code, connection documents, and runtime interfaces should reference stable records instead of redefining concepts independently.

**Status:** Adopted

## Decision 002 — External systems are connections

**Decision:** External platforms, APIs, connectors, and integrations cross an explicit connection boundary.

**Reason:** External systems may connect to internal systems, but they do not own or define legal authority, registry meaning, runtime identity, or relationship truth.

**Status:** Adopted

## Decision 003 — Former public Engine naming

**Decision:** Earlier records designated a full public name for the private execution system.

**Reason:** The earlier decision attempted to keep a consistent external phrase and spelling.

**Status:** Superseded for active public use by Decision 005. Preserve this entry and Git history as provenance; do not treat the former phrase as a current public brand.

## Decision 004 — Workbench is contextual

**Decision:** There is no single generic Workbench.

**Reason:** Library and Laboratory workbench functions are different and must remain distinct.

**Status:** Adopted

## Decision 005 — Public mark claims are paused

**Decision date:** 2026-08-26

**Decision:** Active public trademark and service-mark claims are paused while clearance and filing strategy are reviewed. Public copy uses unmarked names. The private execution system has no approved public product name.

**Reason:** Preliminary screening identified a live federal conflict for the former engine wording, a live federal conflict for `Liquid Logic`, and crowded or common-law risk around several other public-facing names.

**Compatibility rule:** Preserve repository names, database names, commands, routes, schemas, environment variables, and file paths exactly. Label them machine identifiers; do not promote them as brand aliases.

**Historical rule:** Preserve historical evidence. Update active public material; label older material historical or superseded.

**Status:** Adopted as the current public-risk control; legal clearance remains pending.

## Decision 006 — KEJ Studio ownership and display

**Decision date:** 2026-08-26

**Decision:** KEJ Studio is the Florida creative DBA/division owned and operated by Design Orchard LLC. Current public display is `KEJ Studio`, unmarked while clearance remains pending.

**Reason:** This separates the legal operating relationship from trademark status and from unrelated third-party near-match spellings.

**Status:** Adopted


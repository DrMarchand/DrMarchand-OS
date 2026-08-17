# DrMarchand-OS Core Architecture

Status: Canonical foundation
Repository: DrMarchand/DrMarchand-OS
System: DrMarchand’s ∞ OS™
Legal authority: Design Orchard LLC
Public ecosystem: 🌴 Design Orchard™
Maintainer: 🔬 DrMarchand’s Lab⚛︎ratory™

---

## Purpose

DrMarchand-OS is the core engine repository for DrMarchand’s ∞ OS™.

This repository is not only a website, dashboard, or application shell. It is the canonical engine-core repository where system meaning, relationships, registry definitions, and runtime architecture are defined before they are implemented elsewhere.

The Registry is the institutional memory of DrMarchand-OS. README files, license text, code, bridges, runtime interfaces, and future documentation should reference the Registry instead of redefining concepts independently.

---

## Authority Stack

```text
Design Orchard LLC
        ↓
🌴 Design Orchard™
        ↓
🔬 DrMarchand’s Lab⚛︎ratory™
        ↓
DrMarchand-OS
        ↓
Registry / UNI / Atlas / Flywheel / Workbench / Bridges
```

- Design Orchard LLC is the legal authority.
- 🌴 Design Orchard™ is the public ecosystem identity.
- 🔬 DrMarchand’s Lab⚛︎ratory™ is the maintainer and system steward.
- DrMarchand-OS is the core engine repository.

---

## Core Relationship

```text
DrMarchand-OS
        ├── Registry
        ├── UNI
        ├── Atlas
        ├── Flywheel
        ├── Workbench
        ├── Bridges
        └── DrMarchand’s ⚙︎ Nɛuro-Forge Engine™
```

The Registry defines meaning.
UNI provides foundational gear logic.
Atlas maps relationships and coordinates.
The Flywheel manages motion, redirection, and continuity.
The Workbench prepares and validates working forms.
Bridges translate between internal systems and external platforms.
DrMarchand’s ⚙︎ Nɛuro-Forge Engine™ compiles, validates, and prepares executable system definitions.

---

## Source of Truth Rule

```text
Registry = source of truth for meaning
Database = source of truth for runtime data
Code = implementation of behavior
GitHub = source of truth for versioned engineering artifacts
```

Concepts must be defined once in the Registry and referenced elsewhere.

---

## Bridge Boundary Rule

External services, platforms, APIs, connectors, and integrations are not part of the engine directly.

All communication between 🔬 DrMarchand’s Lab⚛︎ratory™ systems and third-party platforms must pass through a dedicated bridge interface. External systems must not be represented as owning or defining the internal authority, Registry, runtime, or Atlas structure.

---

## Registry Spine

```text
registry/
├── CORE_ARCHITECTURE.md
├── concepts/
│   ├── orchard.md
│   ├── laboratory.md
│   ├── drmarchand-os.md
│   ├── uni.md
│   ├── atlas.md
│   ├── flywheel.md
│   ├── workbench.md
│   ├── bridges.md
│   └── neuro-forge-engine.md
├── glossary.md
├── decisions.md
└── relationships.md
```

This file records the proposed Registry structure for the `DrMarchand-OS` repository; controlling status requires evidence and authorized-human approval.

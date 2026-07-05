# DrMarchand-OS Core Architecture

Status: Draft foundation
Repository: DrMarchand/DrMarchand-OS
System: DrMarchand's OS
Owner: Design Orchard LLC
Primary identity: DrMarchand's

## Purpose

DrMarchand-OS is the core engine repository for DrMarchand's OS.

Inside it lives UNI, the foundational gear system that enables Atlas, supports the Neuro-Forge Engine, and connects the Laboratory back to the Orchard.

This repository is not only a website, dashboard, or application shell. It is the canonical engine-core repository where the meaning, structure, and runtime logic of DrMarchand's OS are defined before they are implemented elsewhere.

## Core Relationship

```text
Design Orchard
        ↑
DrMarchand's Laboratory
        ↑
DrMarchand-OS
        ├── UNI
        ├── Atlas
        ├── Neuro-Forge Engine
        ├── Flywheel
        ├── Workbench
        └── Registry
```

## UNI

UNI means one.

UNI is not primarily a brand, license, or contract in this stage. UNI is the internal gear logic that allows the system to operate as one governed engine.

UNI enables:

```text
Atlas to map
Flywheel to redirect
Workbench to craft
Engine to run
Library to remember
Orchard to grow
```

UNI should be treated as a closable, modular, engine-facing gear system. It is hypothetical code first and may later develop legal, commercial, or contractual meaning after the runtime architecture is sufficiently stable.

## Atlas

Atlas is the map layer. Atlas defines nodes, relationships, coordinates, references, and system navigation. Atlas should not be overloaded with business logic.

## Workbench

The Workbench is where engine parts are crafted before they are installed.

## Flywheel

The Flywheel is the motion and direction layer. It allows events and execution paths to change direction without forcing every component to directly depend on every other component.

## Neuro-Forge Engine

The Neuro-Forge Engine is the runtime and orchestration engine. It loads, validates, routes, logs, and executes internal system components.

## Bridges

Bridges are external connectors. They are not part of the engine directly.

A bridge translates between DrMarchand's Laboratory systems and third-party platforms. The engine should speak to bridge interfaces, not directly to external services.

## Registry

The Registry is the source of truth for system meaning.

It should define concepts, components, gears, bridges, tables, functions, decisions, relationships, status, and version history.

## Source of Truth Rule

```text
Registry = source of truth for meaning
Database = source of truth for runtime data
Code = implementation of behavior
GitHub = source of truth for versioned engineering artifacts
```

## Boundary Rule

No external service should communicate directly with the Neuro-Forge Engine.

All communication between DrMarchand's Laboratory and third-party platforms must pass through a dedicated bridge interface.

## Initial Repository Spine

```text
/uni
/atlas
/engine
/workbench
/flywheel
/registry
/docs
```

This file anchors the first definition of the DrMarchand-OS engine-core architecture.

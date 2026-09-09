# DrMarchand’s OS™ - Repository Architecture

Status: current public engineering record  
Repository: `DrMarchand/DrMarchand-OS`  
Legal and operating company: Design Orchard LLC

## Purpose

This repository documents the public engineering model for **DrMarchand’s OS™**: presentation, navigation, routing, lifecycle state, bridge definitions, and release-safe architecture.

It is **not** the Engine core and it is **not** the runtime authority for active display-name policy.

## Authority layers

```text
Design Orchard LLC
  -> authorized human decision
  -> Laboratory operating context
  -> Engine execution / evidence
  -> server identity + runtime state
  -> DrMarchand’s OS™ presentation
  -> Library custody where applicable
```

- **Design Orchard LLC** holds legal and organizational authority for authorized company work.
- **DrMarchand’s ⚙︎ Nɛuro-Forge Engine™** executes and orchestrates within delegated permission.
- **DrMarchand’s OS™** presents, navigates, and routes state; it does not perform Engine execution merely because it displays the result.
- **📚 DrMarchand’s ⚛︎ Library™** preserves eligible records and evidence.

## Identity authority

Active display names are resolved by the private server identity registry. GitHub receives release-safe engineering documentation and, where produced, a safe identity mirror. GitHub is not allowed to redefine the active private registry merely because a string appears in a README, historical commit, or schema.

```text
private server identity registry
        -> safe mirror / documentation
        -> GitHub
```

Credentials, private risk notes, private device names, and unpublished production markers are intentionally excluded from the public mirror.

## OS naming

- **Current system identity:** `DrMarchand’s OS™`
- `Infinity OS` and `Infinite OS` are superseded aliases and are not current names.
- `∞` is an infinite-bridge concept inside the system; it is not a replacement system name.
- Real machine identifiers may retain legacy spellings when compatibility requires them.

## Repository Registry

The `registry/` tree is versioned engineering memory for concepts, decisions, and terminology. It may document intended or observed relationships, but it does not grant legal authority or prove current runtime state by itself.

```text
registry/
  CORE_ARCHITECTURE.md
  decisions.md
  glossary.md
  concepts/
```

The decision ledger is append-oriented: later decisions supersede earlier ones explicitly instead of pretending the earlier record never existed.

## Bridge boundary

External platforms remain external. A Bridge defines the crossing between systems; it does not transfer ownership or make an external platform part of the Engine.

`∞` may be used as the architectural expression for an infinite bridge inside DrMarchand’s OS™. Named Bridge machine identifiers remain coordinates, not brand aliases.

## Evidence rule

Repository files prove their own checked-in content. Runtime, deployment, authentication, custody, and promotion claims require the corresponding direct evidence and authorized-human gate.

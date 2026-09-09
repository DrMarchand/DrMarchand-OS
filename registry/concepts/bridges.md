# Bridges

Status: current concept  
Registry path: `registry/concepts/bridges.md`  
System: DrMarchand’s OS™

## Definition

A Bridge is an explicit interface between a source and target system. It translates a bounded payload across a boundary without transferring ownership, authority, or identity.

## Infinite bridge

The `∞` symbol describes the **infinite bridge** concept inside DrMarchand’s OS™. It is architectural language, not another name for the OS.

## Required boundary

A Bridge should make the following explicit when implemented:

```text
source
-> target
-> direction
-> payload
-> requesting authority
-> execution permission
-> validation
-> failure behavior
-> receipt
```

External platforms remain external. They do not become part of DrMarchand’s ⚙︎ Nɛuro-Forge Engine™ merely because the Engine invokes or validates a Bridge.

## Machine identifiers

Identifiers such as `NFE-BRIDGE` or `OS-BRIDGE` may be used as stable coordinates when an implementation defines them. Their presence in documentation does not prove that a network path, credential, or execution flow is currently active.

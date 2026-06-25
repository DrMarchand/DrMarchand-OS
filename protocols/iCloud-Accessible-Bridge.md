# 🍏🔗 iCloud Accessible Bridge Protocol

## Purpose

🍏 iCloud represents accessible personal folders that can participate in the DrMarchand ecosystem because they do not hold keys, credentials, tokens, secrets, or privileged access material.

This protocol defines iCloud as a keyless personal-access bridge, not as a secret store, canonical architecture source, execution surface, validation authority, or sealed record layer.

---

## Core Definition

🍏 **iCloud = accessible folders that do not hold the keys.**

The iCloud bridge is for human-accessible device files, screenshots, exports, identity materials, symbolic assets, working documents, and local handoff folders that are safe to review and route.

The moment a file contains or appears to contain keys, credentials, API tokens, passwords, recovery phrases, private certificates, or authentication material, it exits the 🍏 iCloud Accessible Bridge classification and becomes 🔐 security-sensitive.

---

## Authority Model

| Layer | Role |
|---|---|
| ⚛︎ GitHub | Canonical architecture and source of truth |
| 🧩 Asana | Live execution mirror |
| 🪬 Big Brother | Drift observation and health reporting |
| ☁️ Google Drive | Cloud-local validation and break-detection loop |
| 🍏 iCloud | Accessible keyless personal bridge folders |
| 🔐 Secrets Process | Keys, tokens, credentials, and privileged material |
| 🪞 OneDrive | Sealed final record layer |
| 🦁 Lionheart | Integrity gate and enforcement authority |

---

## Non-Negotiable Rule

🍏 iCloud folders do not hold the keys.

No key-like file should be mirrored, promoted, synced, committed, or sealed through the ordinary iCloud bridge pipeline.

Secret-like material must be routed to the 🔐 Secrets Process and blocked from normal bridge movement.

---

## Valid iCloud Bridge Responsibilities

🍏 iCloud may be used for:

- Personal device file intake
- Screenshot intake
- Mobile exports
- Draft documents
- Glyph and symbolic asset staging
- Identity material staging that does not include credentials
- Local working-folder handoff
- Human-reviewed personal-to-business transfer
- Bridge folders such as `ICLOUD-DRIVE_BRIDGE`
- Temporary staging before GitHub validation

---

## Prohibited iCloud Bridge Responsibilities

🍏 iCloud must not be used as:

- Credential storage
- API key storage
- Token storage
- Password archive
- Recovery phrase storage
- Private certificate storage
- Canonical architecture source
- Final sealed record authority
- Public release authority
- Automated execution authority
- Replacement for GitHub version control
- Replacement for OneDrive sealed records
- Replacement for Google Drive validation loops

---

## Secret Detection Boundary

A file must be treated as 🔐 security-sensitive if its name, contents, metadata, or context suggests:

- API key
- Access token
- Secret
- Password
- Private key
- Recovery phrase
- Certificate
- OAuth credential
- Session cookie
- Environment file
- `.env`
- `openai-api-key`
- Any provider key or authentication artifact

If detected, the item receives status:

```text
🍏✕ → 🔐 Sensitive Material Detected → Stop Bridge Movement
```

---

## Bridge Pattern

```text
🍏 iCloud Accessible Folder
        │
        ▼
🔗 Bridge Intake
        │
        ▼
🔐 Secret Detection Boundary
        │
        ├── if secret-like → ✕ Block + route to Secrets Process
        │
        ▼
🦁 Lionheart Identity + Boundary Gate
        │
        ▼
⚛︎ GitHub Canon / Issue / Commit
        │
        ▼
🧩 Asana Execution Mirror
        │
        ▼
☁️ Google Drive Validation Loop
        │
        ▼
🪞 OneDrive Sealed Record
```

---

## Intake States

| State | Meaning |
|---|---|
| 🍏 Pending Intake | File exists in accessible iCloud bridge folder but has not been reviewed |
| 🍏❓ Needs Classification | File purpose or destination is unclear |
| 🍏🦁 Needs Lionheart Gate | File may affect identity, canon, publication, or authority |
| 🍏✓ Cleared for Routing | File is accessible, keyless, classified, and may move to the next layer |
| 🍏✕ Blocked | File must not be mirrored or promoted |
| 🔐 Sensitive | File appears credential-related or key-like and leaves the iCloud bridge path |

---

## Pass Conditions

The iCloud Accessible Bridge passes only when:

- ✓ The file is accessible and keyless.
- ✓ File identity is known.
- ✓ File sensitivity has been assessed.
- ✓ Destination layer is defined.
- ✓ GitHub canon is not overwritten.
- ✓ No credential-like file is automatically mirrored.
- ✓ Lionheart gate passes for identity, publication, security, or authority-impacting files.
- ✓ Any promoted artifact receives a traceable ledger entry.

---

## Fail Conditions

The iCloud Accessible Bridge fails when:

- ✕ A file destination is unclear.
- ✕ A file appears credential-related.
- ✕ A personal file attempts to overwrite canon.
- ✕ A public-facing artifact bypasses GitHub validation.
- ✕ A sealed record is attempted directly from iCloud.
- ✕ A personal identity asset is promoted without review.
- ✕ A key-like file is present in an accessible bridge path.

---

## Relationship to Other Layers

- ⚛︎ GitHub remains the canonical architecture source.
- 🧩 Asana reflects execution state.
- ☁️ Google Drive validates cloud-local structure and sync behavior.
- 🪞 OneDrive seals final validated records.
- 🍏 iCloud bridges accessible, keyless personal/device material into the system.
- 🔐 Secrets Process handles keys and credentials outside the accessible bridge.
- 🦁 Lionheart gates movement from iCloud into authoritative or public systems.

---

## Parser Metadata

```yaml
glyphs:
  icloud_accessible_bridge: "🍏"
  bridge: "🔗"
  secret_boundary: "🔐"
  canon: "⚛︎"
  execution: "🧩"
  validation_loop: "☁️"
  sealed_record: "🪞"
  integrity: "🦁"
  pass: "✓"
  fail: "✕"
status: alpha
authority: Design Orchard LLC
source_of_truth: GitHub
personal_accessible_bridge_layer: iCloud
key_storage_allowed: false
secret_like_material_route: Secrets Process
final_sealed_layer: OneDrive
```

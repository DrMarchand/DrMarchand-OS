# Design Orchard OS Starter

Date created: 2026-06-11
Owner: Design Orchard LLC
Purpose: Lightweight local operating layer for turning messy notes into durable documentation.

## What this includes

- Folder structure for projects, SOPs, decisions, research, prompts, systems, and archive
- Markdown templates for reusable documentation
- A Python CLI script: `scripts/orchard.py`
- Example config: `orchard_config.json`

## Fast start

From this folder:

```bash
python scripts/orchard.py init
python scripts/orchard.py brief "My New Project"
python scripts/orchard.py decision "Choose Documentation Stack"
python scripts/orchard.py sop "Client Intake"
python scripts/orchard.py index
```

## Core workflow

1. Put messy notes into `00_inbox/`.
2. Generate a durable document using the CLI.
3. Move finalized docs into the right system folder.
4. Run `python scripts/orchard.py index` to rebuild the local index.

## Design principle

Do not rely on memory. Every important idea, decision, system, process, and automation should become a durable artifact.

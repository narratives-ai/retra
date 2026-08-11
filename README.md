# Retra

Retra is a free, local-first Codex plugin that turns Codex-assisted activity
into evidence-based daily, weekly, and monthly Markdown reviews. It can follow
user-selected themes across software work, learning, research, writing,
planning, and other projects. It can also answer questions from local work
memory, carry unresolved questions, compare periods, apply report corrections,
and track outcome-oriented goals.

Retra has no account, telemetry, or external backend. Its journal stays on the
user's computer. Report generation uses the user's existing Codex session and
OpenAI account.

## Install in Codex

Add the Narratives marketplace and install Retra:

```sh
codex plugin marketplace add narratives-ai/retra
codex plugin add retra@narratives
```

Restart Codex, start a new task, and ask:

```text
Set up Retra on this computer.
```

Codex will ask the user to review and trust Retra's local lifecycle hooks. If a
compatible Python runtime is missing, Retra proposes a supported installer and
waits for normal Codex approval before changing the system.

## Repository layout

- [`plugins/retra/`](plugins/retra/) — installable plugin package.
- [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json) —
  Narratives marketplace catalog.
- [`plugins/retra/tests/`](plugins/retra/tests/) — local unit and intent tests.

Generated reports, SQLite journals, environment files, and local runtime data
are excluded from version control.

## Development

Retra uses only the Python standard library. Run the test suite and manifest
validation from the repository root:

```sh
python3 -m unittest discover -s plugins/retra/tests -v
python3 /path/to/plugin-creator/scripts/validate_plugin.py plugins/retra
```

See [the plugin documentation](plugins/retra/README.md) for the privacy model,
runtime behavior, report hierarchy, and current MVP boundaries.

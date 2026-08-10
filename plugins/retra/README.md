# Retra for Codex

Retra is a free, local-first Codex plugin that turns Codex-assisted
activity into evidence-based daily, weekly, and monthly Markdown reviews. It is
not limited to programming: the same workflow supports learning, research,
writing, planning, wellbeing discussions, professional work, and personal
projects.

## Privacy model

- No Retra account or external backend.
- No telemetry.
- Structured events stay in a local SQLite database.
- Obvious tokens, credentials, and private keys are redacted before storage.
- Tool outputs and full file contents are not retained by default.
- Report generation uses the user's existing Codex session and OpenAI account.

## How it works

Trusted lifecycle hooks record user prompts, final assistant messages, tool
names, compact command summaries, and session boundaries. Read and inspection
tools are aggregated locally; file changes, verification commands, and failures
remain visible as evidence. Daily context pairs each request with its final
recorded result and dynamically compresses every task to preserve full task
coverage before spending space on tool details. The bundled
`work-retrospective` skill reads that local journal and writes reports into a
`Retrospective` folder next to the current project's repository root.
The folder and its basic structure are created automatically by the first
trusted plugin hook; no separate setup command is required in normal use.

Users can ask Codex to track up to ten themes in future reports. Focuses are
stored locally, included as observation lenses during report generation, and
shown in `Tracking.md`. A missing signal means only that the activity was not
recorded in Codex; it does not imply that it did not happen elsewhere.

Daily reviews use compact journal evidence. Weekly reviews read daily reports,
and monthly reviews read weekly reports, so raw activity is not repeatedly sent
through the model at every level. Source bundles default to a 30,000-character
budget and include a local token estimate. Generate reports in a fresh,
dedicated Retra task when possible to avoid unrelated chat history.

For example:

```text
~/Dev/
├── Narrative_iOS/
├── AnotherProject/
└── Retrospective/
    ├── README.md
    ├── Today.md
    ├── Tracking.md
    ├── Daily/
    ├── Weekly/
    ├── Monthly/
    └── Projects/
```

The raw journal remains in Codex's plugin data directory. Only generated
Markdown reports are written into the visible `Retrospective` project. Raw
events older than 30 days are deleted automatically once per active day.
When upgrading from the earlier `retrospective` plugin identifier, Retra copies
the newest legacy SQLite journal once into its new plugin data directory using
SQLite's consistent backup mechanism. The legacy journal is left untouched.

Every report title shows its covered date using the user's language and normal
regional date order. For example: `Retra — 3–9 августа 2026`, US English
`Retra — Aug 3–9, 2026`, or UK English `Retra — 3–9 Aug 2026`. Every title is
followed by exact ISO start and end dates. Filenames remain ISO-based so they
sort reliably and continue to work with automation.

## Commands

The helper uses only the Python standard library. Lifecycle hooks call a
cross-platform bootstrap that checks for Python 3.9+, `sqlite3`, and `zoneinfo`
before invoking the helper. Missing runtimes are installed through a supported
system package manager only after the user approves the onboarding action. The
plugin first reuses a compatible runtime already available on the system or
bundled with Codex, avoiding installation whenever possible.

```text
sh scripts/run-retrospective.sh doctor
sh scripts/run-retrospective.sh setup --cwd /path/to/project
sh scripts/run-retrospective.sh configure --timezone Europe/Moscow --day-closes-at 18:00
sh scripts/run-retrospective.sh closed-report-date
sh scripts/run-retrospective.sh status
sh scripts/run-retrospective.sh focus add --name "Learning progress" --guidance "Notice practiced topics and remaining questions"
sh scripts/run-retrospective.sh focus list --all
sh scripts/run-retrospective.sh focus pause "Learning progress"
sh scripts/run-retrospective.sh context --period daily --date 2026-08-08
sh scripts/run-retrospective.sh report-path --period daily --date 2026-08-08
sh scripts/run-retrospective.sh refresh-index
sh scripts/run-retrospective.sh prune --days 30
```

Set `RETROSPECTIVE_DATA_DIR` and `RETROSPECTIVE_REPORTS_DIR` to override the
default locations during development or testing.

The default workday closes at `00:00` in the detected user timezone. A custom
closing time, such as `18:00`, makes events after that boundary part of the next
workday. This prevents late activity from being lost after an earlier daily
report has already been generated.

## Current MVP boundaries

- Codex is the only supported host.
- The plugin creates the local report folder on the first trusted hook, but the
  current public plugin lifecycle does not register folders in the Projects UI.
- Automatic report generation uses a Codex scheduled task. Creating that task
  remains a user-approved onboarding action because plugin installation does
  not run arbitrary post-install scripts.
- Weekly reports require daily reports for complete coverage; monthly reports
  require weekly reports. Missing sources are reported explicitly.
- The transcript file is not parsed because its format is not a stable hook
  interface.

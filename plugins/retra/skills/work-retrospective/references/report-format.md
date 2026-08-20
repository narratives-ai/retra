# Report formats

## Title and covered period

Every report must begin with two lines:

1. An H1 title in the report's language and normal regional date order:
   `Retra — <human-readable covered date or range>`.
2. An italic metadata line stating the exact inclusive period with ISO dates.
   Translate the `Date` or `Period` label into the report's language.

Examples:

```markdown
# Retra — 10 августа 2026
_Дата: 2026-08-10_

# Retra — 3–9 августа 2026
_Период: 2026-08-03 — 2026-08-09_

# Retra — август 2026
_Период: 2026-08-01 — 2026-08-31_

# Retra — Aug 31–Sep 6, 2026
_Period: 2026-08-31 — 2026-09-06_

# Retra — 31 Aug–6 Sep 2026
_Period: 2026-08-31 — 2026-09-06_

# Retra — 2026年8月31日〜9月6日
_期間: 2026-08-31 — 2026-09-06_
```

Do not translate a fixed month-day template. Follow the user's language and
regional convention: Russian and most continental European formats put the day
before the month; US English puts the month first; UK English puts the day
first; East Asian formats commonly put the year and month first. Infer a known
regional preference from the user's language or request. When English is used
without a regional signal, default consistently to US English (`Aug 3–9,
2026`).

Use a compact localized range when both endpoints share a month or year. When
the range crosses a month or year boundary, include enough information on both
endpoints to remove ambiguity. Never use only an ISO week number such as
`2026-W32` as the visible title. Keep the existing ISO-based filenames because
they remain stable for sorting and automation. The exact ISO metadata line is
required even when the localized title could otherwise be interpreted in more
than one way.

## Heading hierarchy and project grouping

Use exactly this semantic hierarchy:

- `#` — the report title only;
- `##` — report sections such as Outcomes or Decisions;
- `###` — project-root folder names inside every populated section;
- `####` — an individual goal or tracked focus when another heading level is
  needed.

Group every populated `##` section by the basename of the recorded project
root, even when that section contains only one project. Keep each project in
one contiguous block. Use a localized `General` block only for genuinely
cross-project evidence or evidence with no reliable project root. Do not use a
conversation title, task title, or inferred topic in place of the folder name.
Split a combined bullet when it contains distinct facts for different projects;
do not duplicate one fact under multiple projects.

## Daily

```markdown
# Retra — <localized full date>
_<localized Date label>: YYYY-MM-DD_

## Outcomes
### Project folder name
- Completed result with evidence. (`session:...`)

### Another project folder
- Completed result with evidence. (`session:...`)

## Decisions
### Project folder name
- Decision and its recorded rationale. (`session:...`)

## Friction and failed approaches
### Project folder name
- Concrete blocker, failure, or repeated loop. (`session:...`)

## Open threads
### Project folder name
- Work that remains unresolved or whose result was not confirmed.

## Suggested next steps
### Project folder name
- One specific, evidence-grounded action for the next work period.

## Goal progress
### Project folder name or General
#### User-selected goal
- `Progress`, `Completed with explicit evidence`, or `Insufficient recorded evidence`, followed by a factual explanation.

## Tracked signals
### Project folder name or General
#### User-selected focus
- `Observed`, `Progress`, or `Insufficient recorded evidence`, followed by a factual explanation and session citation when available.

```

Omit empty sections except `Outcomes`, `Open threads`, and `Suggested next
steps`. Include `Tracked signals` whenever active focuses are present, covering
every active focus even when the source has insufficient evidence. If no
completed outcome is evidenced, state that clearly. Include `Goal progress`
whenever active goals are present. Preserve the user's language for section
headings. Do not emit HTML comments or `retra:*` tags.

## Weekly

```markdown
# Retra — <localized inclusive date range>
_<localized Period label>: YYYY-MM-DD — YYYY-MM-DD_

## Period overview
### Project folder name
A concise synthesis of progress and direction.

## Meaningful outcomes
### Project folder name
- Result and why it mattered. (`session:...`)

## Decisions that shaped the work
### Project folder name
- Decision, rationale, and consequence when evidenced.

## Recurring friction
### Project folder name
- Repeated blocker or unproductive loop with evidence from multiple events.

## Carried work
### Project folder name
- Important work that moved forward but remains unfinished.

## Next-week priorities
### Project folder name
1. Specific priority grounded in open work.

## Goal progress
### Project folder name or General
#### User-selected goal
- Period-level progress or `Insufficient recorded evidence`.

## Tracked signals
### Project folder name or General
#### User-selected focus
- Period-level signal or `Insufficient recorded evidence`.
```

Include `Goal progress` before `Tracked signals` whenever active goals are
present. Apply the same project grouping and heading hierarchy to weekly and
monthly reports. Weekly and monthly reports may use localized open-work
headings.

## Monthly

Use `# Retra — <localized month and year>` followed by the exact inclusive
first and last dates of the calendar month. Then use the weekly structure,
replacing week-specific language with monthly trends. Emphasize direction
changes, repeated decisions, recurring blockers, and work carried into the
next month.

## Local visualization

Use ordinary Markdown headings only. After the report is saved, the Retra
helper reads the outcome, project, and open-thread sections by their headings
and deterministically generates a local SVG period map. The helper embeds the
image link directly below the report's ISO date or period line. Do not write
HTML boundary comments, SVG markup, or invented chart values in the report
itself.

The visualization shows only evidence already present in the Markdown:
projects or areas, confirmed outcomes, and open threads. It must not display a
productivity score, inferred hours, message volume, or token counts.

## Style

- Use plain language and compact bullets.
- Prefer facts over motivational commentary.
- Avoid reconstructing precise durations unless timestamps establish them.
- Include session citations near the claims they support.
- Write for the user's actual domain. Do not default to programming language or
  software metrics when the source concerns learning, research, wellbeing,
  writing, planning, or another Codex-assisted activity.
- Missing Codex evidence means only that the source did not record a signal; it
  does not prove that the real-world activity did not happen.

## Detail levels and profiles

- `brief`: keep only the highest-signal outcomes, decisions, unresolved work,
  goal movement, and next steps.
- `standard`: use the structures above with compact evidence-backed bullets.
- `detailed`: preserve more rationale, repeated friction, and carried-work
  context without adding unsupported interpretation.

Apply the active profile as emphasis: development favors shipped behavior and
verification; project management favors milestones and dependencies; research
favors questions and uncertainty; learning favors demonstrated understanding;
content favors drafts and publishing; personal favors explicitly discussed
intentions and routines. `general` stays balanced. Profiles never change the
evidence or privacy rules.

## Period comparisons

When answering from a comparison bundle, do not create or overwrite a normal
period report unless asked. Summarize:

1. new outcomes and completed work;
2. carried or newly opened work;
3. changed decisions or direction;
4. recurring or resolved friction;
5. goal movement and the next evidence-grounded priority.

Do not compare activity volume, infer effort, or assign a score.

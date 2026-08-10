# Report formats

## Title and covered period

Every report must begin with two lines:

1. An H1 title in the report's language: `Retra — <human-readable covered date
   or range>`.
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
```

Use a compact localized range when both endpoints share a month or year. When
the range crosses a month or year boundary, include enough information on both
endpoints to remove ambiguity. Never use only an ISO week number such as
`2026-W32` as the visible title. Keep the existing ISO-based filenames because
they remain stable for sorting and automation.

## Daily

```markdown
# Retra — <localized full date>
_<localized Date label>: YYYY-MM-DD_

## Outcomes
- Completed result with evidence. (`session:...`)

## Decisions
- Decision and its recorded rationale. (`session:...`)

## Friction and failed approaches
- Concrete blocker, failure, or repeated loop. (`session:...`)

## Open threads
- Work that remains unresolved or whose result was not confirmed.

## Suggested first step
- One specific, evidence-grounded action for the next work period.

## Tracked signals
### User-selected focus
- `Observed`, `Progress`, or `Insufficient recorded evidence`, followed by a factual explanation and session citation when available.

## Activity by project
### Project name
- Compact factual recap.
```

Omit empty sections except `Outcomes`, `Open threads`, and `Suggested first
step`. Include `Tracked signals` whenever active focuses are present, covering
every active focus even when the source has insufficient evidence. If no
completed outcome is evidenced, state that clearly.

## Weekly

```markdown
# Retra — <localized inclusive date range>
_<localized Period label>: YYYY-MM-DD — YYYY-MM-DD_

## Week in one paragraph
A concise synthesis of progress and direction.

## Meaningful outcomes
- Result and why it mattered. (`session:...`)

## Decisions that shaped the work
- Decision, rationale, and consequence when evidenced.

## Recurring friction
- Repeated blocker or unproductive loop with evidence from multiple events.

## Carried work
- Important work that moved forward but remains unfinished.

## Next-week priorities
1. Specific priority grounded in open work.

## Tracked signals
### User-selected focus
- Period-level signal or `Insufficient recorded evidence`.

## Project breakdown
### Project name
- Progress, risks, and open questions.
```

## Monthly

Use `# Retra — <localized month and year>` followed by the exact inclusive
first and last dates of the calendar month. Then use the weekly structure,
replacing week-specific language with monthly trends. Emphasize direction
changes, repeated decisions, recurring blockers, and work carried into the
next month.

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

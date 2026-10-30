---
name: investigate
description: Investigate incidents and unexplained system behavior using focused code and deployed-state evidence, maintaining a validated Markdown report and permanent worklog.
---

# Investigate

The main coordinator owns the investigation record and all file writes. Keep questions and brief progress updates in conversation; maintain the report and worklog in the file below. Researcher and investigator return evidence in conversation and never write the record.

## Start or resume

At the start of a new investigation, recommend opening `~/Documents/investigations` as the Codex workspace so the record can be written there. A shell `cd` alone does not grant sandbox access. Confirm the destination is permitted and writable before creating the record. If access is unavailable, ask the user to open that directory or grant access through the host; stop file writes and do not claim findings have been saved.

For a new investigation, use `~/Documents/investigations/YYYYMMDD-three-descriptive-words.md`, with the actual UTC start date and exactly three lowercase descriptive words separated by hyphens. Example: `20261030-lambda-checkout-timeouts.md`. Check for collisions and create without overwriting; choose another descriptive three-word name if it exists. Resume an existing investigation only when it is identified as the intended record. Keep its original filename across dates.

Establish the question, observed and expected behavior, impact, environment, affected resources, and time window. Ask for missing information only when it changes the investigation. Read the current record before resuming work.

## Investigation procedure

- Send focused code and documentation questions to `researcher`; send deployed-state and telemetry questions to `investigator`. Give each the scope, time window, known evidence, and question to resolve. Pass concise findings between them through the coordinator and avoid duplicate queries.
- Identify the provider, service, and task from available evidence. Search installed skill metadata, then load only applicable instructions and references. Use required provider and source skills before access; missing skills follow existing discovery and installation rules.
- Preserve existing credential, read-only, and approval restrictions. Investigator requires verified read-only credentials. Neither researcher nor investigator may write, including artifacts, exports, diagnostic jobs, or service exec. A skill or investigation request never authorizes remediation. Operator-related reads retain their separate per-request approval and host-gate requirements.
- Correlate code revisions, deployments, configuration, logs, metrics, and traces in a timeline. Distinguish observation time, event time, and stale evidence. Keep competing hypotheses with supporting evidence, contradicting evidence, and unknowns in the worklog.
- Choose the smallest bounded check that can distinguish explanations. Record query scope, filters, and limitations; do not infer absence from incomplete results or causation from correlation.
- Ask `adversarial_reviewer` to challenge material conclusions and alternative explanations before presenting a final cause. If required access or a diagnostic would change state, stop that path and record the blocker. An unresolved cause is a valid outcome.
- Hand remediation proposals to the coordinator for the existing designer, infrastructure, review, and operator workflow. End with confirmed findings, uncertainty, and useful next steps.

## Record format

Use these two top-level sections and report subsections:

```markdown
# Report

## Executive summary

## Initial report

## Investigation done

## Root cause

## Timeline

## Next steps

## Links/resources

# Worklog
```

Update the Report when relevant information is validated. Include only confirmed or validated information, except that Next steps may contain proposed actions and further research. Attribute initial reports: confirmation that a person reported a symptom does not confirm the symptom itself. Under Investigation done, describe checks actually completed and their established results. Use `Not established` for an unknown root cause; do not promote a plausible hypothesis into the Report. If evidence invalidates a prior conclusion, correct the Report and document the change in a new worklog entry. Prefer source links beside claims as well as in Links/resources.

## Worklog entries

Record every potentially relevant finding promptly, including unvalidated leads clearly tagged as such. Each entry is a complete, self-contained Markdown message: a first line of `YYYY-MM-DDTHH:MM:SSZ [TAG]`, a blank line, then the entire message. Use `INITIAL`, `QUESTION`, `HYPOTHESIS`, `CHECK`, `FINDING`, `DECISION`, `BLOCKER`, or `CORRECTION` as appropriate. Attribute contributions and distinguish evidence from inference.

Obtain the actual current UTC recording time down to seconds from a clock; never invent timestamps or substitute an event time. State historical event times within the message. Keep entries in descending recording-time order, newest at the top directly below `# Worklog`; for equal timestamps, place the newer entry first. If the clock moves behind an existing entry, resolve the time discrepancy before inserting an entry that would break the order or falsify its recording time.

Separate adjacent entries with a blank line, a standalone `---`, and another blank line, outside code fences. An entry may contain multiple paragraphs, lists, commands, log filters, and log excerpts in fenced code blocks. Reserve standalone horizontal rules outside fences for entry boundaries. Include enough context that the entry can be copied alone into Linear, Slack, or another destination. Label commands as proposed or executed; record results only when execution is evidenced. Copying or publishing to another service requires separate authorization.

Prefer permalinks for resources that move, including commit-specific code links. For mutable logs and dashboards, include the exact query time window, relevant identifiers, filters, and observation time. Redact secrets and sensitive values before writing or sharing them.

Treat entries as permanent additions even though new entries are physically inserted at the top. Never delete or rewrite history. Fix errata only, documenting the correction in a new `CORRECTION` entry; a changed conclusion requires a new entry rather than rewriting the old one. Preserve user contributions verbatim except for documented errata.

Before every write, reread the file and make a targeted update that preserves existing entries and user edits. If it changed since the read, reread and reconcile before writing; never overwrite concurrent edits blindly. After writing, inspect the affected Report and new entry, timestamp order, separators, and preservation of the previous worklog. Report persistence failures in conversation and do not claim the record is current until the write succeeds.

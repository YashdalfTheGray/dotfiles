---
name: debug
description: Diagnose code failures, exceptions, and failing tests through focused evidence and reproductions; implement and review a fix when requested. Use investigation for deployed infrastructure evidence.
---

# Debug

The main coordinator owns scope, competing explanations, and agent handoffs. Use the installed roles with their configured models and efforts. Keep findings in the conversation unless the user requests an artifact; no investigation report is required.

## Establish the task

Distinguish a request to explain or diagnose from a request to fix. Explanation alone does not authorize source changes or creation of new artifacts. Continue safe inspection and ask only for missing information that affects the diagnosis or scope.

Capture the exact error, relevant input, expected and actual behavior, affected revision and working-tree changes, runtime and dependency versions, and reproduction conditions. Redact secrets. Follow project-start, script-language, and latest-stable-version rules; obtain approval for any required language-version deviation rather than silently upgrading the project or using an older runtime.

## Trace and reproduce

- Give `researcher` focused questions about the failing execution path, relevant symbols, callers, documentation, and existing tests. It returns cited evidence and unknowns without running tests, installing dependencies, writing temporary files, or changing local or remote state. Required source skills and read-only restrictions still apply.
- Separate observations from hypotheses. Compare plausible explanations against the evidence and select the smallest check that would distinguish them. Avoid whole-repository surveys, broad output dumps, blind retries, and speculative fixes.
- Use `code_writer` for execution that may write local state, including reproductions and tests. Inspect commands, setup hooks, credentials, endpoints, and side effects first. Run only checks covered by the task authorization and workspace permissions. For explanation-only work, request authorization before creating artifacts or changing source; do not treat that request as permission to fix the bug.
- Prefer isolated local fixtures and fakes. Tests and scripts must not silently deploy, mutate remote services, use production data, or bypass cloud credential and approval rules. If a required check has uncertain effects, stop that check and report the limitation.
- Establish the failure before changing behavior when possible. Record the exact command, input, relevant output, and inspected revision. Reduce the reproduction while preserving the failure; explain why the evidence supports the proposed cause. If reproduction is unavailable, state what remains unverified and propose the next useful check instead of claiming a confirmed cause.

## Fix when requested

Give `code_writer` a concise plan tied to the supported diagnosis and expected behavior. Preserve user edits and keep the fix focused. Use established helpers, clear control flow, repository formatting, and comments for non-obvious intent. Do not hide exceptions, weaken assertions, or remove checks merely to make tests pass.

Add a regression test that fails for the original behavior and passes with the fix when practical. Name tests as observed behavior, such as `it('rejects an expired token')` or `test_rejects_expired_token`, without “should.” Run the affected checks and relevant surrounding tests; report exact outcomes and any checks not run. Explain any limitation that prevents demonstrating failure before and success after the fix.

Route architectural decisions to `designer` through the coordinator. If evidence points to deployed configuration or cloud behavior, hand the relevant questions to the investigation workflow and `investigator`. Load that workflow only when needed; do not create its report automatically. Obtain `infrastructure` review before and after changes with operational impact. Debugging does not authorize cloud writes or operator execution.

## Review and report

Have `adversarial_reviewer` challenge material diagnoses and alternative explanations, and perform the first code review when a fix exists. Run `maintainability_reviewer` alongside it for changed code and tests. The author addresses supported findings, reruns affected checks, and requests focused re-review through the coordinator.

Finish with the supported cause or remaining hypotheses, evidence references, changes made if any, reproduction and test outcomes, and unresolved limitations. Distinguish checks actually executed from proposed commands. Never claim a reproduction, passing test, review, or confirmed cause without evidence.

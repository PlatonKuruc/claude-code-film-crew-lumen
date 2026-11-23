# Handoff contract — how the agents pass work on

## Why this exists

We measured our own agent team. Across 72 agent definitions there were 158 mentions of another agent. Only **2** of them were actual calls. 32 were boundaries ("this is not mine, it belongs to X") and 118 were bare mentions with no verb.

The agents knew about each other, so they could name each other. But instead of passing the work on, they wrote a sentence and returned to the main session. Everything flowed through the main session as the single node: **a star, not a network**. Every pass through the center costs context: the main session has to re-read, re-derive and re-brief.

The capacity was there all along. A subagent without a `tools:` line inherits the full tool set, and by default Claude Code lets a subagent spawn subagents of its own (the official docs say up to three layers below the main conversation; `CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH=1` turns nesting off). What was missing was the verb, not the permission.

This contract gives the agents two verbs.

---

## Verb 1 — PASS ON (direct call)

Use it when the neighbor needs **exactly the artifact you just produced**: the same document, the same URL map, the same pricing decision. A round trip through the main session would mean the main session describes the artifact again, and the description is worse than the original.

- **If nesting is turned off in your setup**, Verb 1 is not available: use the marker (Verb 2) and let the main session make the hop.
- **One hop at most.** You may call one neighbor. The neighbor calls nobody else; it returns to the main session. A second hop is the main session's decision, not yours.
- **No fan-out.** One neighbor, not three at once. Three parallel spawns from inside a subagent is exactly the pattern that once burned $50 in a single afternoon.
- **Shared-resource gate.** If you and the neighbor would both WRITE to two or more of the same files or tables, do not call. Return to the main session. That is not collaboration, it is a collision.
- **Pass the neighbor's answer on verbatim, not summarized.** In a blind comparison, the network lost to the star because the caller summarized the neighbor: a nested colorist delivered a full Lab measurement, and only a fraction of it reached the final answer (3 of 8 required prompt changes survived instead of 6). Any intermediary is lossy, whoever it is. Paste the whole answer under `--- answer from <agent-name> (verbatim) ---` and put your comment below it. The one who decides does the shortening, not the courier.

**Allowed direct edges in this pack:**

```
lumen  ⇄  flutter    (the same shot: the light source → what it does to color relationships)
```

Any other edge = return to the main session with the marker. Add an edge only when you have seen the same pair meet repeatedly on the same artifact, not because it feels natural.

---

## Verb 2 — the HANDOFF marker (return, with a ready brief)

Use it in every other case. Instead of the sentence "this belongs to the colorist", end your output with a machine-readable block:

```
HANDOFF → <agent-name>
  :: NEEDS: <numbered questions, not a paragraph — the neighbor knows how many answers to return>
  :: ARTIFACT: <EXACT path to a file — not a directory, and NEVER "below" / "above">
  :: STATE: <what of this exists TODAY — measured, not assumed>
  :: FOR: <the decision the answer serves>
  :: WHY NOT ME: <one sentence>
```

The main session delegates from it **without re-deriving anything**. Without the marker it has to read your whole output and guess the brief. That is the hidden cost of the star.

### Rules learned from the first live run

- **`ARTIFACT` is a path, never a promise.** A marker that said "…and the prompt changes below" sent the neighbor to answer blind, and the neighbor had **no way of knowing something was missing**. A file path is enough (the neighbor reads the content itself, and prefers to). Text that does not travel is worse than nothing.
- **A path to a FILE, not a directory.** You hold the mapping "step → file", the neighbor does not.
- **`STATE` is the field without which the answer can be right and the decision catastrophic.** In the live run, a marker described exactly which routes existed (every count matched), but said nothing about the CMS holding 6 records out of 612. The neighbor answered all 6 questions correctly, and had the marker been trusted, a customer's domain would have been switched over to an empty site. Write into `STATE` what you see and the neighbor does not: which version is approved, how many paid rounds were spent, what the user rejected, what is actually on disk.
- **Every number in the marker says where it comes from.** The same marker presented a count "according to file X" that was not in that file; it was our own unconfirmed proposal from meeting notes. The neighbor found out only after three greps. Label a proposal as a proposal, not as a measurement.
- **`FOR` halves the answer.** Without it the neighbor covers every interpretation. Two standard formulas gave opposite verdicts on the same input, and the neighbor had to return both.

Several neighbors → several markers; the main session decides the order. You do not.

---

## What does NOT change

- **Boundaries stay.** "This is not mine" is a correct sentence. It just has to be followed by a marker or a call, not by silence.
- **The main session stays the arbiter.** A network does not mean agents do what they like. It means an edge that is obvious and cheap does not have to be drawn through the center.
- **The user stays the approver.** Nothing customer-facing, nothing irreversible, nothing paid passes along an edge without the user.

## Why this is a contract and not a sentence in a memory file

A principle about "logging agent handoffs" lived in our notes for months and left **zero** files on disk. A rule written in prose does not change behavior; a format that the receiving side can parse does. That is why every agent in this pack carries the marker block in its own definition, and why the main session should delegate from the marker verbatim instead of interpreting it.

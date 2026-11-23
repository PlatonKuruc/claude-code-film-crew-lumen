# Shot lifecycle — the rules that stop you paying for the same shot twice

In our studio, across 11 AI image and video projects, **46 % of generation spend went to shots that needed more than three attempts**. Not because the models were bad. Because rounds repeated instead of anchoring on what was already approved. These rules are what `cue` enforces; they work just as well as a checklist without any agent.

## The order

| # | Step | What it costs | Rule |
|---|---|---|---|
| 0 | Check what exists | nothing | Search your own approved frames and earlier work first. "Nothing found" always comes with where you looked. |
| 1 | Look references | nothing | 3–8 references on a contact sheet; the user picks by eye. No pick, no paid generation. |
| 2 | Brief and facts | nothing | What the shot must show; claims checked at the primary source; real-world content confirmed, not guessed. |
| 3 | Free previz | nothing | Composition, camera, positions in a blockout, clay render, mock-up photo or sketch. One class of error per round, max 3 rounds. |
| 4 | One test generation | the cheapest | Cheapest model, lowest resolution that tests the hypothesis. |
| 5 | Human approval | — | The user decides by eye. Claims only about what was opened and seen. |
| 6 | Anchor | nothing | The approved frame goes into `approved.json` and into every following round as the reference. |
| 7 | Derived formats | cheap | Crops and aspect ratios from the approved master, never regenerated. |
| 8 | Safe zones | nothing | Captions, logo, CTA inside the platform's current safe zone, checked over the whole timeline. |

## Three bans

1. **One variable per round.** Change pose OR light OR wardrobe, never two. Hold the rest by reference.
2. **Never "done" without evidence.** Open the output and say what you see; say what you could not judge.
3. **The anchor is the approved master.** Not "a nice earlier frame". Every round carries it.

## File conventions

**Versions:** `<shot>_vNNN.<ext>` — `s01_hero_v001.png`, `s01_hero_v002.png`. Never overwrite a version; a new attempt is a new number.

**Manifest:** `approved.json` in the project root. Plain JSON, no tool required:

```json
{
  "project": "spring-campaign",
  "shots": {
    "s01_hero": {
      "approved": "renders/s01_hero_v004.png",
      "approved_at": "2026-10-16",
      "by": "user",
      "why": "light from frame left, product fully visible",
      "derived": ["renders/s01_hero_v004_9x16.png", "renders/s01_hero_v004_1x1.png"]
    }
  }
}
```

Only the user's approval writes `approved`. An agent may propose; it does not approve.

## Churn self-check (end of every session)

Count versions per shot. **More than 3 versions of a shot = a round repeated instead of anchoring.** Four warning lines:

- money on shots with more than 3 versions is above 30 % of the session's cost,
- fewer than 80 % of paid generations carried a reference,
- fewer than 0.2 free previz renders per paid generation,
- no `approved.json`.

A quick count in a shell:

```bash
ls renders | sed -E 's/_v[0-9]+\..*$//' | sort | uniq -c | sort -rn | awk '$1 > 3'
```

"100 % of generations had a reference" can still be expensive: check that the reference was the **approved** one.

## Optional block for your CLAUDE.md

The installer does not edit `CLAUDE.md`. If you want the main session to follow the rules even when no agent is called, paste this:

```markdown
## Film crew rules (image and video generation)
- Before any paid image or video generation, use `cue`.
  Order: look references → brief → free previz → one cheap test → user approves → anchor in approved.json → derived formats.
- One variable per round. The anchor is the approved master. Never "done" without opening the output.
- Name outputs `<shot>_vNNN`, never overwrite. More than 3 versions of a shot = stop and anchor.
- Before an expensive generation: `lumen` (shot intent) and `shelby` (GO/FIX).
```

# Lumen: an AI director of photography agent for Claude Code

Lumen, a senior director of photography agent for Claude Code: turns a script into a shot list and shot intent (composition, lens, camera move, light) for AI-generated images and video, in wording the models actually obey.

This is **1 of the 8 agents** in the [Wizalnut AI Film Crew for Claude Code](https://wizalnut.com/en/packs). Free to use; see `LICENSE.md`.

## Install as a Claude Code plugin

```bash
claude plugin marketplace add PlatonKuruc/claude-code-film-crew-lumen
claude plugin install claude-code-film-crew-lumen@claude-code-film-crew-lumen
```

Start a new session afterwards. `claude plugin uninstall claude-code-film-crew-lumen@claude-code-film-crew-lumen` removes it. Your `settings.json` is not touched.

Or install without the plugin system: `bash install.sh` (`--dry-run` shows every change first).

---

# Lumen, free: lights every shot

Wizalnut AI Film Crew 0.4.0 for Claude Code. This zip is one of its eight agents, free.

**Lumen** (`lumen`) owns: Shot list and shot intent: composition line, angle, lens, camera move, light as measured fields, and wording models actually obey

## What is inside

- `agents/lumen.md` - the agent
- `SHOT_LIFECYCLE.md` - the order, three bans, `approved.json` and the churn self-check; works as a checklist even without the agent
- `HANDOFF_CONTRACT.md` - how agents pass work on (the agent points to it)
- `install.sh` - installs, never overwrites, uninstalls cleanly
- `LICENSE.md`

## Install

```bash
unzip wizalnut-film-crew-free-lumen-*.zip && cd wizalnut-film-crew-free-lumen-*/
bash install.sh            # --dry-run shows every change first
```

It writes `~/.claude/agents/lumen.md` and `~/.claude/film-crew/`. If you already have an agent called `lumen`, it is left untouched and the installer says so. It does not edit `settings.json` or `CLAUDE.md`. Restart Claude Code (or open `/agents`) and try: *"use lumen: ..."*.

Remove it: `bash install.sh --uninstall` (a file you edited since is kept).

## Not in this zip

These files name 7 other crew members that are **not** installed: `croak`, `cue`, `ember`, `flutter`, `shade`, `shelby`, `silk`. When a hand-off points to one of them, the agent still tells you who should take the next step; you do that part yourself, or get the full crew.

## The full crew

All 8 agents, the Look Lab tools, an installer with `--prefix` for name clashes and a ready rules block for your `CLAUDE.md`: https://wizalnut.com/en/packs (AI Film Crew).

## License

`LICENSE.md` applies to this free copy in the same way as to a purchased one: use it on your own machines, do not resell or redistribute it.

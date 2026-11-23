#!/usr/bin/env bash
# Wizalnut AI Film Crew - free single agent: lumen
#   bash install.sh               install into ~/.claude
#   bash install.sh --home DIR    install into another Claude home
#   bash install.sh --dry-run     show what would change, touch nothing
#   bash install.sh --uninstall   remove exactly what this installer wrote (edited files are kept)
# Never overwrites a file you already have. Does not edit settings.json or CLAUDE.md.
# Uses the same manifest as the full pack, so the full installer upgrades these files later.
set -uo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"; DRY=0; UNINSTALL=0
while [ $# -gt 0 ]; do
  case "$1" in
    --home) CLAUDE_HOME="$2"; shift 2 ;;
    --home=*) CLAUDE_HOME="${1#--home=}"; shift ;;
    --dry-run) DRY=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    -h|--help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done
command -v python3 >/dev/null 2>&1 || { echo "missing dependency: python3" >&2; exit 1; }
python3 - "$HERE" "$CLAUDE_HOME" "$DRY" "$UNINSTALL" "lumen" <<'EOF'
import hashlib, os, sys
here, home, dry, uninstall, agent = sys.argv[1], sys.argv[2], sys.argv[3] == "1", sys.argv[4] == "1", sys.argv[5]
team = os.path.join(home, "film-crew")
manifest = os.path.join(team, "film-crew.manifest")
FILES = [(os.path.join(here, "agents", agent + ".md"), os.path.join(home, "agents", agent + ".md"))] + \
        [(os.path.join(here, d), os.path.join(team, d)) for d in ("SHOT_LIFECYCLE.md", "HANDOFF_CONTRACT.md")]
sha = lambda b: hashlib.sha256(b).hexdigest()
entries = {}
if os.path.exists(manifest):
    for line in open(manifest, encoding="utf-8"):
        line = line.rstrip("\n")
        if line and not line.startswith("#") and "  " in line:
            d, p = line.split("  ", 1); entries[p] = d
def save():
    if dry:
        return
    if entries:
        os.makedirs(team, exist_ok=True)
        with open(manifest, "w", encoding="utf-8") as f:
            f.write("# Wizalnut AI Film Crew - files written by install.sh (sha256  path)\n")
            f.write("".join(f"{d}  {p}\n" for p, d in sorted(entries.items())))
    elif os.path.exists(manifest):
        os.remove(manifest)
pre = "[dry-run] " if dry else ""
if uninstall:
    print(f"Wizalnut AI Film Crew (free: {agent}) - uninstall from {home}")
    for _, dst in FILES:
        if dst not in entries or not os.path.exists(dst):
            continue
        if sha(open(dst, "rb").read()) != entries[dst]:
            print(f"  kept (edited since install): {dst}")
            continue
        print(f"  {pre}remove {dst}")
        if not dry:
            os.remove(dst)
            del entries[dst]
    save()
    if not dry and os.path.isdir(team) and not os.listdir(team):
        os.rmdir(team)
    print("  done")
    sys.exit(0)
print(f"Wizalnut AI Film Crew (free: {agent}) - install into {home}{'  (dry run)' if dry else ''}")
for src, dst in FILES:
    data = open(src, "rb").read()
    if os.path.exists(dst):
        cur = open(dst, "rb").read()
        if cur == data:
            print(f"  up to date: {dst}")
            continue
        if not (dst in entries and sha(cur) == entries[dst]):
            print(f"  SKIPPED - you already have {dst}, left untouched")
            continue
    print(f"  {pre}write {dst}")
    if not dry:
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        with open(dst, "wb") as f:
            f.write(data)
        entries[dst] = sha(data)
save()
print("")
print("Next: restart Claude Code (or open /agents) so it picks up the agent.")
print(f"Try it: ask Claude to \"use {agent}: ...\". Rules checklist: {os.path.join(team, 'SHOT_LIFECYCLE.md')}")
EOF

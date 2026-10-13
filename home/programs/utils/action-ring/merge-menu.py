"""Apply the managed Kando menu without replacing unrelated user menus."""

import argparse
import datetime
import json
import os
from pathlib import Path
import shutil
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument("source", type=Path)
parser.add_argument("destination", type=Path)
parser.add_argument("--actions", required=True)
args = parser.parse_args()
menu = json.loads(args.source.read_text())


def resolve_commands(item):
    for action in item.get("selectWorkflow", {}).get("actions", []):
        if action.get("type") == "execute-command":
            action["command"] = action["command"].replace("@ACTIONS@", args.actions)
    for child in item.get("children", []):
        resolve_commands(child)


resolve_commands(menu["root"])
dest = args.destination
data = json.loads(dest.read_text()) if dest.exists() else {
    "version": "3.0.0", "menus": [], "collections": []
}
old = data.get("menus", [])
updated = []
inserted = False
for existing in old:
    if existing.get("root", {}).get("name") == menu["root"]["name"]:
        if not inserted:
            updated.append(menu)
            inserted = True
    else:
        updated.append(existing)
if not inserted:
    updated.append(menu)
if updated == old:
    raise SystemExit(0)
data["menus"] = updated
dest.parent.mkdir(parents=True, exist_ok=True)
if dest.exists():
    backups = dest.parent / "backups"
    backups.mkdir(exist_ok=True)
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S-%f")
    shutil.copy2(dest, backups / f"menus-before-action-ring-{stamp}.json")
with tempfile.NamedTemporaryFile(mode="w", dir=dest.parent, delete=False) as temp:
    json.dump(data, temp, ensure_ascii=False, indent=2)
    temp.write("\n")
    temp_path = Path(temp.name)
try:
    os.replace(temp_path, dest)
finally:
    temp_path.unlink(missing_ok=True)

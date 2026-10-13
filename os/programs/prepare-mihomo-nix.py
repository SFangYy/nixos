"""Prepare a private, independent Mihomo configuration for Nix downloads."""

import argparse
import os
from pathlib import Path
import shutil

import yaml

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("source", type=Path)
parser.add_argument("destination", type=Path)
parser.add_argument("--assets", type=Path, required=True)
args = parser.parse_args()
config = yaml.safe_load(args.source.read_text())
config.update(
    {
        "mixed-port": 7893,
        "port": 0,
        "socks-port": 0,
        "redir-port": 0,
        "tproxy-port": 0,
        "allow-lan": False,
        "bind-address": "127.0.0.1",
        "external-controller": "",
        "external-controller-unix": "",
        "authentication": [],
        "tun": {"enable": False},
        "dns": {"enable": False},
    }
)
args.destination.parent.mkdir(parents=True, exist_ok=True)
for source in args.assets.iterdir():
    if source.is_file() and (
        source.suffix.lower() in {".dat", ".mmdb", ".metadb"}
        or source.name == "cache.db"
    ):
        target = args.destination.parent / source.name
        if not target.exists() or target.stat().st_size != source.stat().st_size:
            shutil.copyfile(source, target)
temp = args.destination.with_suffix(".tmp")
with temp.open("w") as handle:
    yaml.safe_dump(config, handle, allow_unicode=True, sort_keys=False)
temp.chmod(0o600)
os.replace(temp, args.destination)

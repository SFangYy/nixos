"""Regression checks for desktop layout, host switching and environment setup."""

import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import yaml

ROOT = Path(os.environ.get("NIXOS_CONFIG_ROOT", Path(__file__).resolve().parents[1]))
RING = ROOT / "home/programs/utils/action-ring"
spec = importlib.util.spec_from_file_location(
    "mouse_switch", RING / "switch-mouse-host.py"
)
mouse = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mouse)


class Device:
    def __init__(self, accept_after=None, unexpected=False):
        self.accept_after = accept_after
        self.unexpected = unexpected
        self.writes = 0

    def feature_request(self, feature, function, *args, **kwargs):
        if function == 0x10:
            self.writes += 1
            return None
        return bytes([3, 2 if self.unexpected and self.writes else 0])

    def ping(self):
        return not (self.accept_after and self.writes >= self.accept_after)


class MouseTests(unittest.TestCase):
    def test_departure_verified(self):
        dev = Device(1)
        self.assertEqual(
            mouse.switch_host(dev, 1, 1, delay=lambda _: None), "left-source-host"
        )
        self.assertEqual(dev.writes, 1)

    def test_ignored_command_retried(self):
        dev = Device(2)
        self.assertEqual(
            mouse.switch_host(dev, 1, 1, delay=lambda _: None), "left-source-host"
        )
        self.assertEqual(dev.writes, 2)

    def test_still_connected_is_failure(self):
        dev = Device()
        with self.assertRaisesRegex(RuntimeError, "remained"):
            mouse.switch_host(dev, 1, 1, delay=lambda _: None)
        self.assertEqual(dev.writes, 3)

    def test_unexpected_host_not_overwritten(self):
        dev = Device(unexpected=True)
        with self.assertRaisesRegex(RuntimeError, "unexpectedly"):
            mouse.switch_host(dev, 1, 1, delay=lambda _: None)
        self.assertEqual(dev.writes, 1)

    def test_current_host_not_rewritten(self):
        dev = Device()
        self.assertEqual(mouse.switch_host(dev, 1, 0), "already-selected")
        self.assertEqual(dev.writes, 0)

    def test_layout_matches_kando_angle_contract(self):
        menu = json.loads((RING / "menu.json").read_text())
        items = menu["root"]["children"]
        self.assertEqual([item["angle"] for item in items], [0, 60, 120, 180, 240, 300])
        bottom = next(item for item in items if item["angle"] == 180)
        self.assertEqual(bottom["type"], "button")
        self.assertTrue(
            any(
                action.get("command", "").endswith("switch-macos")
                for action in bottom["selectWorkflow"]["actions"]
            )
        )


class FileTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def test_menu_merge_preserves_unrelated_data(self):
        dest = self.root / "menus.json"
        unrelated = {"root": {"name": "Personal menu", "children": []}}
        original = {
            "version": "3.0.0",
            "menus": [unrelated],
            "collections": [{"name": "mine"}],
        }
        dest.write_text(json.dumps(original))
        command = [
            sys.executable,
            str(RING / "merge-menu.py"),
            str(RING / "menu.json"),
            str(dest),
            "--actions",
            "/test/actions",
        ]
        subprocess.run(command, check=True)
        changed = json.loads(dest.read_text())
        self.assertEqual(changed["menus"][0], unrelated)
        self.assertEqual(changed["collections"], original["collections"])
        before = dest.read_bytes()
        subprocess.run(command, check=True)
        self.assertEqual(dest.read_bytes(), before)
        self.assertEqual(len(list((self.root / "backups").iterdir())), 1)

    def test_proxy_is_private_and_has_no_desktop_listeners(self):
        source = self.root / "config.yaml"
        config = {
            "mixed-port": 7890,
            "tun": {"enable": True},
            "dns": {"enable": True},
            "proxies": [{"name": "test", "password": "private-test-value"}],
        }
        source.write_text(yaml.safe_dump(config))
        (self.root / "geosite.dat").write_bytes(b"test asset")
        dest = self.root / "private/config.yaml"
        subprocess.run(
            [
                sys.executable,
                str(ROOT / "os/programs/prepare-mihomo-nix.py"),
                str(source),
                str(dest),
                "--assets",
                str(self.root),
            ],
            check=True,
        )
        prepared = yaml.safe_load(dest.read_text())
        self.assertEqual(prepared["mixed-port"], 7893)
        self.assertEqual(prepared["bind-address"], "127.0.0.1")
        self.assertFalse(prepared["allow-lan"])
        self.assertFalse(prepared["tun"]["enable"])
        self.assertFalse(prepared["dns"]["enable"])
        self.assertEqual(prepared["proxies"], config["proxies"])
        self.assertEqual(dest.stat().st_mode & 0o777, 0o600)
        self.assertEqual((dest.parent / "geosite.dat").read_bytes(), b"test asset")

    def test_dependency_changes_detected_despite_store_timestamps(self):
        project = self.root / "UCAgent project"
        project.mkdir()
        requirements = project / "requirements.txt"
        requirements.write_text("first dependency")
        (project / "pyproject.toml").write_text("project metadata")
        tools = self.root / "bin"
        tools.mkdir()
        trace = self.root / "trace"
        uv = tools / "uv"
        uv.write_text(f"""#!{sys.executable}
import os, pathlib, sys
with open(os.environ['TRACE'], 'a') as log: log.write(' '.join(sys.argv[1:]) + '\\n')
if sys.argv[1] == 'venv':
    root = pathlib.Path(sys.argv[-1]); (root / 'bin').mkdir(parents=True)
    (root / 'bin/python').symlink_to(sys.executable)
    (root / 'bin/activate').write_text('export VIRTUAL_ENV="' + str(root) + '"\\n')
""")
        uv.chmod(0o755)
        env = os.environ | {
            "PATH": str(tools) + ":" + os.environ["PATH"],
            "UCAGENT_ROOT": str(project),
            "TRACE": str(trace),
            "UCAGENT_WHEEL_RPATH": "",
        }
        command = [
            "bash",
            "-c",
            'source "$1"',
            "bash",
            str(ROOT / "home/programs/shell/prepare-ucagent-env.sh"),
        ]
        subprocess.run(command, env=env, check=True)
        subprocess.run(command, env=env, check=True)
        self.assertEqual(trace.read_text().count("pip install"), 1)
        requirements.write_text("changed dependency")
        os.utime(requirements, (1, 1))
        subprocess.run(command, env=env, check=True)
        self.assertEqual(trace.read_text().count("pip install"), 2)
        self.assertIn(str(project), trace.read_text())


if __name__ == "__main__":
    unittest.main()

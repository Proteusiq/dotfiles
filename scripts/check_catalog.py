#!/usr/bin/env python3
"""Check that every tool in the Brewfile and mise config has an entry in bin/tools.py.

Keeps the `tools` catalog and `update --info` in sync with what is installed.
Standard library only, so it runs in git hooks and CI without a virtualenv.
"""

import re
import sys
import tomllib
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
BREWFILE = REPO / "Brewfile"
MISE_CONFIG = REPO / "mise" / ".config" / "mise" / "config.toml"
TOOLS_CATALOG = REPO / "bin" / "tools.py"

# Libraries, fonts and helpers that other tools need; not worth a catalog entry.
NOT_CATALOGUED = {
    "binutils",
    "diffutils",
    "findutils",
    "ffmpegthumbnailer",
    "font-hack-nerd-font",
    "font-symbols-only-nerd-font",
    "ghostscript",
    "gnu-tar",
    "gnu-time",
    "gnu-which",
    "graphviz",
    "grep",
    "gzip",
    "moreutils",
    "pam-reattach",
    "poppler",
    "portaudio",
    "tectonic",
    "unar",
    "usage",
    "zlib",
}

# Catalog names that differ from the package name.
CATALOG_NAMES = {
    "npm:@earendil-works/pi-coding-agent": "pi",
}

BREWFILE_ENTRY = re.compile(r'^(?:brew|cask|uv|cargo)\s+"([^"]+)"', re.MULTILINE)
CATALOG_ENTRY = re.compile(r'\(\s*"([^"]+)",\s*"')


def package_name(entry: str) -> str:
    """'azure/azd/azd' -> 'azd', 'harlequin[duckdb]' -> 'harlequin'."""
    return entry.rsplit("/", 1)[-1].split("[", 1)[0]


def declared_tools() -> set[str]:
    brew = {
        package_name(entry) for entry in BREWFILE_ENTRY.findall(BREWFILE.read_text())
    }
    mise_tools = tomllib.loads(MISE_CONFIG.read_text())["tools"]
    mise = {CATALOG_NAMES.get(name, name) for name in mise_tools}
    return (brew | mise) - NOT_CATALOGUED


def main() -> int:
    catalogued = set(CATALOG_ENTRY.findall(TOOLS_CATALOG.read_text()))
    missing = sorted(declared_tools() - catalogued)
    if missing:
        print("Installed but missing from bin/tools.py:", ", ".join(missing))
        print(
            "Add an entry, or list the package in NOT_CATALOGUED in",
            Path(__file__).name,
        )
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())

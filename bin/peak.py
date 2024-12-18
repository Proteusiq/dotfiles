#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "rich >= 13.8.1",
#   "duckdb >= 1.1.3",
# ]
# ///
""" Peak onto Tables in DB WIP """
from rich.console import Console
from rich.table import Table


console = Console()
table = Table(title="DataX")

table.add_column("Name", justify="right", style="cyan", no_wrap=True)
table.add_column("Title", style="magenta")
table.add_column("Age", style="green")

for row in (["Prayson", "Principal Data Scientist", "38"],
            ["Shahnoza", "Senior Data Scientist", "32"],
            ["Mette", "Data Scientist", "34"]):
    table.add_row(*row)

console.print(table)

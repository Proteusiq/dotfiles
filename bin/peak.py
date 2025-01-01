#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "rich >= 13.8.1",
#   "duckdb >= 1.1.3",
#   "typer >= 0.15.1",
# ]
# ///
"""Peak onto Tables in DB WIP"""
 
import random
from enum import Enum
from pathlib import Path
from typing import Annotated

import duckdb
import typer
from rich.console import Console
from rich.table import Column, Table
from rich.theme import Theme

app = typer.Typer(name="Peak")

console = Console(theme=Theme({"repr.number": "bold green blink"}))
print = console.print

STYLES = [
    "cyan",
    "magenta",
    "green",
    "blue",
]

show_tables = {
    "sqlite": "SHOW tables;",
    "postgres": """
            SELECT table_name 
            FROM information_schema.tables
            WHERE table_schema = 'public'; 
          """,
}

class Kind(str, Enum):
    sqlite = "sqlite"
    postgres = "postgres"


@app.command()
def open(
    source: Annotated[Path, typer.Argument(help="data source uri")],
    get: Annotated[str, typer.Option(help="table name")] = "",
    limit: Annotated[int, typer.Option(help="number of show rows")] = 5, 
    kind: Annotated[Kind, typer.Option(help="database kind")] = Kind.sqlite,
):
    if not get:
        get = source.stem
        with duckdb.connect(source) as con:
            results = con.sql(show_tables.get(kind, "sqlite"))
            table = Table(
                Column(header="Tables", justify="right", style="cyan"),
                title=f"\n{source.name}",
            )
            for row in results.fetchall():
                table.add_row(row[0])

            print(table)
        raise typer.Exit()

    table = Table(title=get)
    with duckdb.connect(source) as con:
        results = con.sql(f"SELECT * FROM {get} LIMIT {limit};")

        for column in results.columns:
            table.add_column(column, style=random.choice(STYLES))

        for row in results.fetchall():
            table.add_row(*row)

        print(table)



if __name__ == "__main__":
    app()

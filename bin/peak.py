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
from os import environ
from enum import Enum
from pathlib import Path
from typing import Annotated, Optional

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


_ = [duckdb.sql(f"INSTALL {db.value};") for db in Kind]


@app.command()
def open(
    source: Annotated[Optional[Path], typer.Option(help="data source uri")] = None,
    get: Annotated[Optional[str], typer.Option(help="table name")] = None,
    limit: Annotated[int, typer.Option(help="number of show rows")] = 5,
    kind: Annotated[Kind, typer.Option(help="database kind")] = Kind.sqlite,
):
    if (source := environ.get("CONNECTION_STRING", source)) is None:  # type: ignore
        print(
            "Missing [bold cyan]source [/]. Pass in source or set environment variable CONNECTION_STRING"
        )
        raise typer.Exit()

    if get is None:
        list_tables(source=source, kind=kind)
        raise typer.Exit()

    show_table(source=source, table=get, limit=limit)


def list_tables(source: Path, kind: Kind) -> None:
    with duckdb.connect(source) as con:
        results = con.sql(show_tables.get(kind, "sqlite"))
        t = Table(
            Column(header="Tables", justify="right", style="cyan"),
            title=f"\n{kind.value}",
        )
        for row in results.fetchall():
            t.add_row(row[0])
    print(t)


def show_table(source: Path, table: str, limit: int = 5) -> None:
    t = Table(title=table)
    with duckdb.connect(source) as con:
        results = con.sql(f"SELECT * FROM {table} LIMIT {limit};")

        for column in results.columns:
            t.add_column(column, style=random.choice(STYLES))

        for row in results.fetchall():
            t.add_row(*row)

        print(t)


if __name__ == "__main__":
    app()

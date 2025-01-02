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

connection = {
    "sqlite": "ATTACH '{source}' (TYPE SQLITE);",
    "postgres": "ATTACH '{source}' AS db (TYPE POSTGRES, READ_ONLY, SCHEMA 'public');",
}


class Kind(str, Enum):
    sqlite = "sqlite"
    postgres = "postgres"


_ = [duckdb.sql(f"INSTALL {db.value};") for db in Kind]


@app.command()
def open(
    source: Annotated[Optional[str], typer.Option(help="data source uri")] = None,
    get: Annotated[Optional[str], typer.Option(help="table name")] = None,
    limit: Annotated[int, typer.Option(help="number of show rows")] = 5,
    kind: Annotated[Optional[Kind], typer.Option(help="database kind")] = None,
):
    if (source := environ.get("CONNECTION_STRING", source)) is None:  # type: ignore
        print(
            "Missing [bold cyan]source [/]. Pass in source or set environment variable CONNECTION_STRING"
        )
        raise typer.Exit()

    if kind is not None:
        source = source[source.find(kind):]
    else:
        kind = Kind.sqlite # set default

    if get is None:
        list_tables(source=source, kind=kind)
        raise typer.Exit()

    show_table(source=source, table=get, limit=limit, kind=kind)


def list_tables(source: str, kind: Kind) -> None:
    
    duckdb.sql(connection.get(kind).format(source=source))
    results = duckdb.sql("SHOW ALL tables;")
    t = Table(
        Column(header="Tables", justify="right", style="cyan"),
        title=f"\n{kind.value}",
    )
    for row in results.fetchall():
        t.add_row(row[0])
    print(t)


def show_table(source: str, table: str, limit: int = 5, kind:Kind=Kind.sqlite) -> None:
    t = Table(title=table)
    duckdb.sql(connection.get(kind).format(source=source))
    results = duckdb.sql(f"SELECT * FROM db.public.{table} LIMIT {limit};")

    for column in results.columns:
        t.add_column(column, style=random.choice(STYLES))

    for row in results.fetchall():
        t.add_row(*row)

    print(t)


if __name__ == "__main__":
    app()

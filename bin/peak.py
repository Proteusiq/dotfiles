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
from pathlib import Path
from enum import Enum
from typing import Annotated, Optional
from typing import NamedTuple

import duckdb
import typer
from rich.console import Console
from rich.table import Table
from rich.theme import Theme

app = typer.Typer(
    name="Peak",
    rich_markup_mode="markdown",
    no_args_is_help=True,
)

console = Console(theme=Theme({"repr.number": "bold green blink"}))
print = console.print

STYLES = [
    "cyan",
    "magenta",
    "green",
    "blue",
]


class SQL(NamedTuple):
    table: str
    query: str


class Flavor(str, Enum):
    sqlite = "sqlite"
    postgres = "postgres"


_ = [duckdb.sql(f"INSTALL {db.value};") for db in Flavor]


@app.command()
def open(
    source: Annotated[
        Optional[str],
        typer.Option("--source", "-s", help="data source uri", envvar="CONNECTION_STRING"),
    ] = None,
    table: Annotated[
        Optional[str], typer.Option("--get", "-g", help="table name")
    ] = None,
    limit: Annotated[int, typer.Option("--limit", "-l", help="number of show rows")] = 5,
    flavor: Annotated[
        Flavor, typer.Option("--flavor", "-f", help="database flavor")

    ] = Flavor.sqlite,
):
    if source is None:
        print(
            "Missing [bold cyan]source [/]. Pass in source or set environment variable CONNECTION_STRING"
        )
        raise typer.Exit()

    table, query = generate_query(
        source=source, table=table, flavor=flavor, limit=limit
    )
    show_table(table=table, query=query)


def show_table(
    table: str,
    query: str,
) -> None:
    t = Table(title=table)
    results = duckdb.sql(query)

    for column in results.columns:
        t.add_column(column, style=random.choice(STYLES))

    for row in results.fetchall():
        t.add_row(*row)

    print(t)


def generate_query(
    source: str,
    table: str | None = None,
    limit: int = 5,
    flavor: Flavor = Flavor.sqlite,
) -> SQL:
    connection = {
        "sqlite": f"ATTACH '{source}' (TYPE SQLITE);USE {Path(source).stem};",
        "postgres": f"""ATTACH '{source}' AS db (TYPE POSTGRES, READ_ONLY, SCHEMA 'public');
    USE db.public;""",
    }
    duckdb.sql(connection[flavor])

    if table is None:
        table = "Tables"
        query = "SHOW tables"
    else:
        query = f"SELECT * FROM {table} LIMIT {limit};"

    return SQL(table=table, query=query)


if __name__ == "__main__":
    app()

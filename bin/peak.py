#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "rich >= 13.8.1",
#   "duckdb >= 1.1.3",
#   "typer >= 0.15.1",
# ]
# ///
"""Peak onto Tables in DB - A quick database explorer

Examples:
    # Explore SQLite database
    peak -s example.db
    peak -s example.db -g users -l 10

    # Explore Postgres database
    peak -s "postgres://user:pass@localhost:5432/db"
    peak -s "postgres://user:pass@localhost:5432/db" -g customers --debug

    # Use from environment variable
    export CONNECTION_STRING="postgres://user:pass@localhost:5432/db"
    peak -g orders -l 20
"""

import random
import logging
from pathlib import Path
from enum import Enum
from typing import Annotated, NamedTuple, Optional

import duckdb
import typer
from rich.console import Console
from rich.table import Table
from rich.theme import Theme

# Setup logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger(__name__)

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
        Optional[str], 
        typer.Option("--get", "-g", help="table name"),
    ] = None,
    limit: Annotated[
        int,
        typer.Option("--limit", "-l", min=1, help="number of show rows"),
    ] = 5,
    debug: Annotated[
        bool,
        typer.Option("--debug", help="Enable debug logging"),
    ] = False,
):
    """
    ---

    source code: [proteusiq/dotfiles bin](https://github.com/Proteusiq/dotfiles/blob/main/bin/peak.py)
    """

    if debug:
        logger.setLevel(logging.DEBUG)
        logger.debug("Debug mode enabled")

    if source is None:
        print(
            "Missing [bold cyan]source[/]. Pass in source or set environment variable CONNECTION_STRING"
        )
        raise typer.Abort()
    
    flavor = get_flavor(source)
    logger.debug(f"Detected database flavor: {flavor}")

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


def get_flavor(source: str) -> Flavor:
    for flavor in Flavor:
        if flavor.value in source:
            return flavor
    return Flavor.sqlite


if __name__ == "__main__":
    app()

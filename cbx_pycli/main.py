import sys

import structlog
import colorama # type: ignore

import typer
from rich.traceback import install
from rich import print

cr = structlog.dev.ConsoleRenderer(
    columns=[
        # Render the timestamp without the key name in yellow.
        structlog.dev.Column(
            "timestamp",
            structlog.dev.KeyValueColumnFormatter(
                key_style=None,
                value_style=colorama.Fore.YELLOW,
                reset_style=colorama.Style.RESET_ALL,
                value_repr=str,
            ),
        ),
        # Render the event without the key name in bright magenta.
        structlog.dev.Column(
            "event",
            structlog.dev.KeyValueColumnFormatter(
                key_style=None,
                value_style=colorama.Style.BRIGHT + colorama.Fore.MAGENTA,
                reset_style=colorama.Style.RESET_ALL,
                value_repr=str,
            ),
        ),
        # Default formatter for all keys not explicitly mentioned. The key is
        # cyan, the value is green.
        structlog.dev.Column(
            "",
            structlog.dev.KeyValueColumnFormatter(
                key_style=colorama.Fore.CYAN,
                value_style=colorama.Fore.GREEN,
                reset_style=colorama.Style.RESET_ALL,
                value_repr=str,
            ),
        ),
    ]
)

structlog.configure(processors=structlog.get_config()["processors"][:-1]+[cr])

log = structlog.get_logger()

install(show_locals=True)

app = typer.Typer()

@app.command()
def main(name: str):
    print(f"Hello {name}")

if __name__ == "__main__":
    app()

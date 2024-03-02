from typing import Optional

import colorama  # type: ignore

import structlog
import typer
from rich import print
from rich.traceback import install
from typing_extensions import Annotated

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

structlog.configure(processors=structlog.get_config()["processors"][:-1] + [cr])

log = structlog.get_logger()

install(show_locals=True)

def callback2():
    print("Running a command")

app = typer.Typer(rich_markup_mode="rich", callback=callback2)
state = {"verbose": False}


@app.command("bruh")
def puto_bruh(
    name: Annotated[
        str,
        typer.Argument(
            ..., help="The [green]name[/green] to say hello to", metavar="✨username✨"
        ),
    ],
    last_name: Annotated[Optional[str], typer.Argument()] = None,
    force: Annotated[
        bool, typer.Option(help="Force the [bold red]deletion[/bold red] :boom:")
    ] = False,
):
    log.info("Hello", name=name, last_name=last_name)

    print(f"Are yoou a [bold blue]bitch[/bold blue] ? {force}")

    if last_name is not None:
        name = f"{name} {last_name}"
    else:
        name = name

    print(f"Hello, {name}!")


@app.command("bruh2")
def puto_bruh2(
    name: Annotated[
        str,
        typer.Argument(
            ..., help="The [green]name[/green] to say hello to", metavar="✨username✨"
        ),
    ]
):
    print(f"{name}")

# Ovveride callback2
# @app.callback()
# def main(verbose: bool = False):
#     """
#     Manage users in the awesome CLI app.
#     """
#     if verbose:
#         print("Will write verbose output")
#         state["verbose"] = True


if __name__ == "__main__":
    app()

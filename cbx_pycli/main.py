import typer
from InquirerPy.base.control import Choice
from invoke import Context
from rich import print
from cbx_pycli.prompts import select_prompt
from cbx_pycli.tasks import python_versioning


app = typer.Typer(rich_markup_mode="rich")

init_app = typer.Typer(rich_markup_mode="rich")


app.add_typer(init_app, name="init")


@app.command()
def list_python_versions():
    """List installed python versions"""
    ctx = Context()
    python_versioning.list_available(ctx)


@app.command()
def start():
    choices = [
        Choice(value="1", name="Docker \U0001F433"),
        Choice(value="2", name="Poetry \U0001F4D6"),
        Choice(value="3", name="Git \U0001F33F"),
    ]

    user_choice = select_prompt(
        choices=choices,
        default="1",
        message="Wich type of command do you want to run ?",
    )

    print(f"You chose: {user_choice}")

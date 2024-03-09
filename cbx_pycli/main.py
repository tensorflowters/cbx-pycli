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
    choices = python_versioning.list_all_python_version_to_install(ctx)

    user_version_choice = select_prompt(
        choices=choices,
        message="Select a python version to install \u2622\uFE0F",
        default="199-200-201",
    )

    print(user_version_choice)


@app.command()
def run():
    choices = [
        Choice(value="1", name="Python version \U0001F40D"),
        Choice(value="2", name="Poetry \U0001F4D6"),
        Choice(value="3", name="Docker \U0001F433"),
        Choice(value="4", name="Git \U0001F33F"),
    ]

    user_choice = select_prompt(
        choices=choices,
        default="1",
        message="Where do we start :rocket:?",
    )

    if user_choice == "1":
        list_python_versions()

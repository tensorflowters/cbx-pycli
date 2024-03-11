import typer # type: ignore
from InquirerPy.base.control import Choice # type: ignore
from invoke import Context # type: ignore
from rich import print # type: ignore
from rich.prompt import Prompt

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
        message="Which version of python you wish to install \U0001F4E6 ?",
        default="199-200-201",
    )

    releases_by_version = python_versioning.ls_py_by_version(ctx, choices, user_version_choice)

    releases_choices = [
        Choice(value=str(index), name=release) for index, release in enumerate(releases_by_version[0]['packages'])
    ]

    python_release_emoji = "🐍🚀"

    user_release_choice = select_prompt(
        choices=releases_choices,
        default="1",
        message=f"Which {releases_by_version[0]['name']} release do you want to install {python_release_emoji} ?",
    )

    python_version_to_install = releases_by_version[0]['packages'][int(user_release_choice)]

    python_versioning.install_python_version(ctx, python_version_to_install)
    
    is_default = Prompt.ask(f"Do you want to use {python_version_to_install} as your default python version ?", choices=["Yes", "No"], default="Yes", show_choices=True)
    
    if is_default == "Yes":
        python_versioning.set_python_version(ctx, python_version_to_install)



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
        message="Select type of task to run \U0001F680",
    )

    if user_choice == "1":
        list_python_versions()

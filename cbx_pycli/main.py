import typer  # type: ignore
from InquirerPy.base.control import Choice  # type: ignore
from invoke import Context  # type: ignore
from rich.prompt import Prompt
from typing_extensions import Annotated, Optional

from cbx_pycli.prompts import select_prompt, default_prompt
from cbx_pycli.tasks import git, python_versioning, docker


app = typer.Typer(rich_markup_mode="rich")

init_app = typer.Typer(rich_markup_mode="rich")


app.add_typer(init_app, name="init", hidden=True)


@app.command()
def pyinstall():
    """Installed python version"""
    ctx = Context()
    choices = python_versioning.list_all_python_version_to_install(ctx)

    user_version_choice = select_prompt(
        choices=choices,
        message="Which version of python you wish to install \U0001F4E6 ?",
        default="199-200-201",
    )

    releases_by_version = python_versioning.ls_py_by_version(
        ctx, choices, user_version_choice
    )

    releases_choices = [
        Choice(value=str(index), name=release)
        for index, release in enumerate(releases_by_version[0]["packages"])
    ]

    python_release_emoji = "🐍🚀"

    user_release_choice = select_prompt(
        choices=releases_choices,
        default="1",
        message=f"Which {releases_by_version[0]['name']} release do you want to install {python_release_emoji} ?",
    )

    python_version_to_install = releases_by_version[0]["packages"][
        int(user_release_choice)
    ]

    python_versioning.install_python_version(ctx, python_version_to_install)

    is_default = Prompt.ask(
        f"Do you want to use {python_version_to_install} as your default python version ?",
        choices=["Yes", "No"],
        default="Yes",
        show_choices=True,
    )

    if is_default == "Yes":
        python_versioning.set_python_version(ctx, python_version_to_install)


@app.command()
def pyls():
    """List installed python versions"""
    ctx = Context()
    python_versioning.list_installed(ctx)


@app.command()
def pyuse(version: Annotated[Optional[str], typer.Argument()] = None):
    """Use python version"""
    ctx = Context()
    if version is None:
        choices = python_versioning.list_installed(ctx)
        user_version_choice = select_prompt(
            choices=choices,
            message="Which version of python you wish to use \U0001F4E6 ?",
            default=choices.index("system"),
        )
        version = user_version_choice

    python_versioning.set_python_version(ctx, version)


@app.command()
def dkbuild():
    """Run docker build command with context env values"""
    ctx = Context()
    file = default_prompt(message="Docker compose file: ", default_key="compose_file", default="docker-compose.yml")
    project = default_prompt(message="Project name: ", default_key="project", default=None)
    env_file = default_prompt(message="Docker compose env file path: ", default_key="env", default=".env")
    docker.build(ctx, file, project, env_file)

@app.command()
def gitpub():
    """Publish to git"""
    ctx = Context()
    git.publish(ctx)


@app.command()
def select():
    """Prompt to select a command to run"""
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
        pyinstall()

import itertools
import logging

import pandas as pd  # type: ignore
from invoke import task
from rich.logging import RichHandler

# logging.basicConfig(
#     level="NOTSET",
#     format="%(message)s",
#     datefmt="[%X]",
#     handlers=[RichHandler(rich_tracebacks=True)],
# )

log = logging.getLogger("rich")


def generate_unique_id(group):
    # Extraire les index du groupe et les convertir en chaîne de caractères
    index_str = "-".join(
        itertools.chain.from_iterable(str(index) for index in group.index)
    )
    return index_str


@task
def list_installed(ctx):
    ctx.run("pyenv versions")


@task
def list_all_python_version_to_install(ctx):
    runned_command = ctx.run("pyenv install -l", hide=True, warn=True)
    if runned_command.ok:
        all_python_version_list = runned_command

        all_python_version_list = [
            dict(
                full_name=python_package.replace(" ", ""),
                version=python_package.replace(" ", "").split("-")[0],
                release=python_package.replace(" ", "").split("-")[-1],
            )
            for python_package in all_python_version_list.stdout.split("\n")[1:-1]
        ]

        all_python_standard_normalized_version = [
            (
                dict(
                    full_name=python_standard_package_to_normalize["full_name"],
                    release=python_standard_package_to_normalize["release"],
                    version="python",
                )
                if python_standard_package_to_normalize["full_name"]
                == python_standard_package_to_normalize["release"]
                else python_standard_package_to_normalize
            )
            for python_standard_package_to_normalize in all_python_version_list
        ]

        all_python_dev_normalized_version = [
            (
                dict(
                    full_name=python_dev_package_to_normalize["full_name"],
                    release=python_dev_package_to_normalize["release"],
                    version="python",
                )
                if python_dev_package_to_normalize["full_name"][0] == "3"
                or python_dev_package_to_normalize["full_name"][0] == "2"
                and f'{python_dev_package_to_normalize["version"]}-{python_dev_package_to_normalize["release"]}'
                == python_dev_package_to_normalize["full_name"]
                and python_dev_package_to_normalize["release"] == "dev"
                and python_dev_package_to_normalize["full_name"] != "mambaforge"
                else python_dev_package_to_normalize
            )
            for python_dev_package_to_normalize in all_python_standard_normalized_version
        ]

        df = pd.DataFrame(all_python_dev_normalized_version)

        all_python_package_group_by_version = df.groupby("version")

        all_python_package_group_by_version.groups.keys()

        all_python_package_group_by_version_group_dict = [
            dict(
                name=version,
                value="-".join(map(str, group["full_name"].keys().to_list())),
                packages=group["full_name"].to_list(),
            )
            for version, group in all_python_package_group_by_version
        ]

        return all_python_package_group_by_version_group_dict

    else:
        log.exception(runned_command.stderr)
        return runned_command.stderr


@task
def ls_py_by_version(
    ctx, all_normalized_python_version: dict, search_version_type: str
) -> list:
    serch_version_type_group = list(
        filter(
            lambda x: x["version"] == f"{search_version_type}",
            all_normalized_python_version,
        )
    )
    return serch_version_type_group

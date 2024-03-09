import pandas as pd # type: ignore
from invoke import task
from rich import print


@task
def list_installed(ctx):
    ctx.run("pyenv versions")


@task
def list_available(ctx):
    run_cmd = ctx.run("pyenv install -l", hide=True, warn=True)
    if run_cmd.ok:
        list_cmd = run_cmd
        list_cmd = [
            dict(
                version=ele.replace(" ", "").split("-")[-1],
                short_name=ele.replace(" ", "").split("-")[0],
                name=ele.replace(" ", ""),
            )
            for ele in list_cmd.stdout.split("\n")[1:-1]
        ]
        standard_list = [
            (
                dict(
                    short_name="python",
                    name=py_dict["name"],
                    version=py_dict["version"],
                )
                if py_dict["name"] == py_dict["version"]
                else py_dict
            )
            for py_dict in list_cmd
        ]
        standard_list_dev = [
            (
                dict(
                    short_name="python",
                    name=py_dict["name"],
                    version=py_dict["version"],
                )
                if py_dict["name"][0] == "3" or py_dict["name"][0] == "2" and f'{py_dict["short_name"]}-{py_dict["version"]}' == py_dict["name"] and py_dict["version"] == "dev"
                else py_dict
            )
            for py_dict in standard_list
        ]
        df = pd.DataFrame(standard_list_dev)
        short_name = df.groupby('short_name')
        print(short_name.groups.keys())
        all_val = list(filter(lambda x: x['short_name'] == 'jython', standard_list_dev))
        print(all_val)


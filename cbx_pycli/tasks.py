import os

from invoke import Collection, Config

from .tasks import docker, git, poetry, python_versioning


current_path = os.getcwd()

ns = Collection.from_module(Config(project_location=current_path))

ns.add_collection(Collection.from_module(docker), name="docker")
ns.add_collection(Collection.from_module(git), name="git")
ns.add_collection(Collection.from_module(poetry), name="poetry")
ns.add_collection(Collection.from_module(python_versioning), name="python_versioning")

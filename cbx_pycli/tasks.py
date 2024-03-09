from invoke import Collection
from .tasks import docker, git, poetry, python_versioning

ns = Collection()

ns.add_collection(Collection.from_module(docker), name='docker')
ns.add_collection(Collection.from_module(git), name='git')
ns.add_collection(Collection.from_module(poetry), name='poetry')
ns.add_collection(Collection.from_module(python_versioning), name='python_versioning')

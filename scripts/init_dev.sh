# For dev only, in the package build this script will be replace by the postinst file
#!/usr/bin/env bash

set -e

# Install pyenv
source $(echo $(pwd)/scripts/install_pyenv.sh)

PYENV_VERSION=3.12.1
VENV_PATH=$(echo $(pwd)/.venv)

pyenv install $PYENV_VERSION
pyenv local $PYENV_VERSION

pyenv exec python3 -m venv $VENV_PATH

$VENV_PATH/bin/pip install -U pip setuptools
$VENV_PATH/bin/pip install poetry

poetry config --local
poetry install

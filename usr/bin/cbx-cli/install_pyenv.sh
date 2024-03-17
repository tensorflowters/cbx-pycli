#!/usr/bin/env bash

source /usr/bin/cbx-cli/get_os.sh
source /usr/bin/cbx-cli/get_shell.sh

detect_os
detect_shell

PYENV_ROOT=/usr/bin/cbx-cli/.pyenv

echo -e "\n\033[36mOS: $CBX_VAR_OS\033[0m"
echo -e "\033[36mShell: $CBX_VAR_SHELL\033[0m\n"
echo -e "\033[36mPyenv root directory: $PYENV_ROOT\033[0m\n"

# Check if the value equals "ubuntu"
if [ "$CBX_VAR_DISTRIBUTION" = "Ubuntu" ]; then
  if [ -d "${PYENV_ROOT}" ]; then
    if [ "$(ls -A ${PYENV_ROOT} | wc -l)" -eq 0 ]; then
      echo -e "Mise à jour du submodule pyenv.\n"
      git submodule sync
      git submodule update --init
    else
      echo -e "\033[32mPyenv content is up to date \033[0m\n"
    fi
  else
    # Check if .pyenv is already in the Git index
    if git ls-files --error-unmatch .pyenv > /dev/null 2>&1; then
      echo -e "The '.pyenv' directory already exists in the Git index. Attempting to initialize and update it as a submodule.\n"
      # Attempt to deinitialize in case it's stuck in a bad state
      git submodule deinit .pyenv --force
      # Re-add the submodule to ensure it's correctly tracked
      git submodule add https://github.com/pyenv/pyenv.git .pyenv
      git submodule update --init --recursive
    else
      # If .pyenv is not in the index, add it as a new submodule
      git submodule add https://github.com/pyenv/pyenv.git .pyenv
      git submodule update --init --recursive
    fi
  fi

  CBX_PYENV_ROOT_EXPORT="export PYENV_ROOT=\"$PYENV_ROOT\""
  CBX_PYENV_ROOT_TO_PATH="[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
  CBX_PYENV_ROOT_INIT='eval "$(pyenv init -)"'

  if [[ "$CBX_VAR_SHELL" == */bash ]]; then
    echo "Configuration pour bash."
    XSH_PATH=~/.bashrc
    XSH_PROFILE=~/.profile
    XSH_LOGIN=~/.bash_login
  elif [[ "$CBX_VAR_SHELL" == */zsh ]]; then
    echo "Configuration pour zsh."
    XSH_PATH=~/.zshrc
    XSH_PROFILE=~/.zprofile
    XSH_LOGIN=~/.zlogin
  else
    echo "Ce script est conçu uniquement pour bash ou zsh."
    return 1
  fi

  grep -qxF "$CBX_PYENV_ROOT_EXPORT" "$XSH_PATH" || echo "$CBX_PYENV_ROOT_EXPORT" >>"$XSH_PATH"
  grep -qxF "$CBX_PYENV_ROOT_TO_PATH" "$XSH_PATH" || echo "$CBX_PYENV_ROOT_TO_PATH" >>"$XSH_PATH"
  grep -qxF "$CBX_PYENV_ROOT_INIT" "$XSH_PATH" || echo "$CBX_PYENV_ROOT_INIT" >>"$XSH_PATH"

  grep -qxF "$CBX_PYENV_ROOT_EXPORT" "$XSH_PROFILE" || echo "$CBX_PYENV_ROOT_EXPORT" >>"$XSH_PROFILE"
  grep -qxF "$CBX_PYENV_ROOT_TO_PATH" "$XSH_PROFILE" || echo "$CBX_PYENV_ROOT_TO_PATH" >>"$XSH_PROFILE"
  grep -qxF "$CBX_PYENV_ROOT_INIT" "$XSH_PROFILE" || echo "$CBX_PYENV_ROOT_INIT" >>"$XSH_PROFILE"

  grep -qxF "$CBX_PYENV_ROOT_EXPORT" "$XSH_LOGIN" || echo "$CBX_PYENV_ROOT_EXPORT" >>"$XSH_LOGIN"
  grep -qxF "$CBX_PYENV_ROOT_TO_PATH" "$XSH_LOGIN" || echo "$CBX_PYENV_ROOT_TO_PATH" >>"$XSH_LOGIN"
  grep -qxF "$CBX_PYENV_ROOT_INIT" "$XSH_LOGIN" || echo "$CBX_PYENV_ROOT_INIT" >>"$XSH_LOGIN"

  $CBX_VAR_SHELL -c ". $XSH_PATH"

  rm -rf /usr/bin/cbx-cli/docs
  rm -rf /usr/bin/cbx-cli/tests
  rm -rf /usr/bin/cbx-cli/makefile
  rm -rf /usr/bin/cbx-cli/poetry.*
  rm -rf /usr/bin/cbx-cli/pyproject.toml
  rm -rf /usr/bin/cbx-cli/README.md
  rm -rf /usr/bin/cbx-cli/.git
  rm -rf /usr/bin/cbx-cli/.github
  rm -rf /usr/bin/cbx-cli/.gitignore
  rm -rf /usr/bin/cbx-cli/.travis.yml
  rm -rf /usr/bin/cbx-cli/.vscode
  rm -rf /usr/bin/cbx-cli/.history
  rm -rf /usr/bin/cbx-cli/.mypy_cache
  rm -rf /usr/bin/cbx-cli/cbx_cli

  echo -e "\033[32mPyenv version: $(pyenv --version)\033[0m\n"
else
  echo "OS is not Ubuntu"
  return 1
fi

#!/usr/bin/env bash

source $(echo /usr/bin/cbx-cli/get_os.sh)
source $(echo /usr/bin/cbx-cli/get_shell.sh)

detect_os
detect_shell

PYENV_ROOT=/usr/bin/cbx-cli/.pyenv

echo -e "\n\033[36mOS: $CBX_VAR_OS\033[0m"
echo -e "\033[36mShell: $CBX_VAR_SHELL\033[0m\n"
echo -e "\033[36mPyenv root directory: $PYENV_ROOT\033[0m\n"

# Check if the value equals "ubuntu"
if [ "$CBX_VAR_DISTRIBUTION" = "Ubuntu" ]; then

  CBX_PYENV_ROOT_EXPORT="export PYENV_ROOT=\"$PYENV_ROOT\""
  CBX_PYENV_ROOT_TO_PATH="[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
  CBX_PYENV_ROOT_INIT='eval "$(pyenv init -)"'

  if [[ "$CBX_VAR_SHELL" == */bash ]]; then
    echo "Configuration pour bash."
    XSH_PATH=~/.bashrc
    XSH_PATH_TMP=~/.bashrc_tmp
    XSH_PROFILE=~/.profile
    XSH_PROFILE_TMP=~/.profile_tmp
    XSH_LOGIN=~/.bash_login
    XSH_LOGIN_TMP=~/.bash_login_tmp
  elif [[ "$CBX_VAR_SHELL" == */zsh ]]; then
    echo "Configuration pour zsh."
    XSH_PATH=~/.zshrc
    XSH_PATH_TMP=~/.zshrc_tmp
    XSH_PROFILE=~/.zprofile
    XSH_PROFILE_TMP=~/.zprofile_tmp
    XSH_LOGIN=~/.zlogin
    XSH_LOGIN_TMP=~/.zlogin_tmp
  else
    echo "Ce script est conçu uniquement pour bash ou zsh."
    exit 1
  fi

  expressions=(
    "$CBX_PYENV_ROOT_EXPORT"
    '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    'eval "$(pyenv init -)"'
  )

  files=("$XSH_PATH" "$XSH_PROFILE" "$XSH_LOGIN")

  for file in "${files[@]}"; do
    for expression in "${expressions[@]}"; do
      if grep -qF -- "$expression" "$file"; then
        tmp_file="${file}_tmp"
        grep -vF -- "$expression" "$file" >"$tmp_file"
        chmod +rxw $tmp_file
        cat "$tmp_file" >"$file"
        rm -f "$tmp_file"
      fi
    done
  done

  $CBX_VAR_SHELL -c ". $XSH_PATH"

  echo -e "\033[32mPyenv unistalled\033[0m\n"
else
  echo "OS is not Ubuntu"
  exit 1
fi

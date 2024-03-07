#!/bin/bash

# Installation de pyenv

json_os=$(cat $(pwd)/os_info.json)
json_shell=$(cat $(pwd)/shell_info.json)
os=$(echo "$json_os" | jq -r '.shell')
shell=$(echo "$json_shell" | jq -r '.shell')

echo -e "\n\033[36mOS: $os\033[0m"
echo -e "\033[36mShell: $shell\033[0m\n"

# Check if the value equals "ubuntu"
if [ "$os" = "Ubuntu" ]; then
  if [ "$shell" = "/usr/bin/zsh" ]; then
    dir="$HOME/.pyenv"
    echo "Pyenv default installation directory is $dir"
    if [ ! -d "$dir" ]; then
      curl https://pyenv.run | bash
      echo PYENV_ROOT="$HOME/.pyenv" >>~/.zshrc
      echo export PATH="$HOME/.pyenv/bin:$PATH" >>~/.zshrc
    else
      echo -e "\033[33mChecking if Pyenv is already installed...\033[0m\n"
      if [[ ! $PATH =~ *(.pyenv)* ]]; then
        echo '\n' >>~/.zshrc
        echo '# Pyenv' >>~/.zshrc
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.zshrc
        echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.zshrc
        echo 'eval "$(pyenv init -)"' >>~/.zshrc
      else
        echo "Pyenv is already installed"
      fi
      echo -e "\033[32mPyenv version: $(pyenv --version)\033[0m\n"
    fi
  else
    echo "OS is Ubuntu but shell is not zsh"
  fi
else
  echo "OS is not Ubuntu" && exit 1
fi

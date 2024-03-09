#!/usr/bin/env zsh

# Installation de pyenv

json_os=$(cat $(pwd)/os_info.json)
json_shell=$(cat $(pwd)/shell_info.json)
os=$(echo "$json_os" | jq -r '.shell')
shell=$(echo "$json_shell" | jq -r '.shell')
PYENV_ROOT=$(echo $(pwd)/.pyenv)

echo -e "\n\033[36mOS: $os\033[0m"
echo -e "\033[36mShell: $shell\033[0m\n"
echo -e "\033[36mShell: $PYENV_ROOT\033[0m\n"

# Check if the value equals "ubuntu"
if [ "$os" = "Ubuntu" ]; then
  if [ "$shell" = "/usr/bin/zsh" ]; then
    echo -e "\033[33mChecking if Pyenv is already installed...\033[0m\n"
    if [ -d "${PYENV_ROOT}" ]; then
      echo -e "\033[36mPyenv already installed\033[0m\n"
    else
      git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT

      echo "export PYENV_ROOT=\"$PYENV_ROOT\"" >>~/.zshrc
      echo "[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >>~/.zshrc
      echo 'eval "$(pyenv init -)"' >>~/.zshrc

      echo "export PYENV_ROOT=\"$PYENV_ROOT\"" >>~/.zprofile
      echo "[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >>~/.zprofile
      echo 'eval "$(pyenv init -)"' >>~/.zprofile

      echo "export PYENV_ROOT=\"$PYENV_ROOT\"" >>~/.zlogin
      echo "[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >>~/.zlogin
      echo 'eval "$(pyenv init -)"' >>~/.zlogin

      . ~/.zshrc
    fi
    echo -e "\033[32mPyenv version: $(pyenv --version)\033[0m\n"
  elif [ "$shell" = "/usr/bin/bash" ]; then
    if [ -d "${PYENV_ROOT}/.pyenv" ]; then
      echo -e "\033[36mPyenv already installed\033[0m\n"
    else
      git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT

      echo "export PYENV_ROOT=\"$PYENV_ROOT\"" >>~/.bashrc
      echo "command -v pyenv >/dev/null || export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >>~/.bashrc
      echo 'eval "$(pyenv init -)"' >>~/.bashrc

      echo "export PYENV_ROOT=\"$PYENV_ROOT\"" >>~/.bash_profile
      echo "[[ -d \$PYENV_ROOT/bin ]] && export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >>~/.bash_profile
      echo 'eval "$(pyenv init -)"' >>~/.bash_profile

      echo "export PYENV_ROOT=\"$PYENV_ROOT\"" >>~/.profile
      echo "command -v pyenv >/dev/null || export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >>~/.profile
      echo 'eval "$(pyenv init -)"' >>~/.profile

      . ~/.bashrc
    fi
  else
    echo "OS is Ubuntu but shell is not handle"
  fi
else
  echo "OS is not Ubuntu" && exit 1
fi

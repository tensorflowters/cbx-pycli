#!/usr/bin/env zsh

json_os=$(cat $(pwd)/os_info.json)
json_shell=$(cat $(pwd)/shell_info.json)
os=$(echo "$json_os" | jq -r '.shell')
shell=$(echo "$json_shell" | jq -r '.shell')
PYENV_ROOT=$(echo $(pwd))

echo -e "\n\033[36mOS: $os\033[0m"
echo -e "\033[36mShell: $shell\033[0m\n"
echo -e "\033[36mPyenv root directory: $PYENV_ROOT/.pyenv\033[0m\n"

# Check if the value equals "ubuntu"
if [ "$os" = "Ubuntu" ]; then
  if [ "$shell" = "/usr/bin/zsh" ]; then
    echo -e "\033[33mChecking if Pyenv is already installed...\033[0m\n"
    if [ "grep -v 'export PYENV_ROOT=' ~/.zshrc" ]; then
      # Uninstallation de pyenv
      grep -v 'export PYENV_ROOT="$HOME/.pyenv"' ~/.zshrc >~/.zshrc_tmp && mv ~/.zshrc_tmp ~/.zshrc
      grep -v '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.zshrc >~/.zshrc_tmp && mv ~/.zshrc_tmp ~/.zshrc
      grep -v 'eval "$(pyenv init -)"' ~/.zshrc >~/.zshrc_tmp && mv ~/.zshrc_tmp ~/.zshrc

      grep -v 'export PYENV_ROOT="$HOME/.pyenv"' ~/.zprofile >~/.zprofile_tmp && mv ~/.zprofile_tmp ~/.zprofile
      grep -v '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.zprofile >~/.zprofile_tmp && mv ~/.zprofile_tmp ~/.zprofile
      grep -v 'eval "$(pyenv init -)"' ~/.zprofile >~/.zprofile_tmp && mv ~/.zprofile_tmp ~/.zprofile

      grep -v 'export PYENV_ROOT="$HOME/.pyenv"' ~/.zlogin >~/.zlogin_tmp && mv ~/.zlogin_tmp ~/.zlogin
      grep -v '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.zlogin >~/.zlogin_tmp && mv ~/.zlogin_tmp ~/.zlogin
      grep -v 'eval "$(pyenv init -)"' ~/.zlogin >~/.zlogin_tmp && mv ~/.zlogin_tmp ~/.zlogin

      . ~/.zshrc

      echo -e "\033[32mPyenv uninstalled\033[0m\n"
    else
      echo -e "\033[36mPyenv not installed\033[0m\n"
    fi
  elif [ "$shell" = "/usr/bin/bash" ]; then
    if [ "grep -v 'export PYENV_ROOT=' ~/.bashrc" ]; then
      # Uninstallation de pyenv
      grep -v 'export PYENV_ROOT="$HOME/.pyenv"' ~/.bashrc >~/.bashrc_tmp && mv ~/.bashrc_tmp ~/.bashrc
      grep -v '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.bashrc >~/.bashrc_tmp && mv ~/.bashrc_tmp ~/.bashrc
      grep -v 'eval "$(pyenv init -)"' ~/.bashrc >~/.bashrc_tmp && mv ~/.bashrc_tmp ~/.bashrc

      grep -v 'export PYENV_ROOT="$HOME/.pyenv"' ~/.bash_profile >~/.bash_profile_tmp && mv ~/.bash_profile_tmp ~/.bash_profile
      grep -v '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.bash_profile >~/.bash_profile_tmp && mv ~/.bash_profile_tmp ~/.bash_profile
      grep -v 'eval "$(pyenv init -)"' ~/.bash_profile >~/.bash_profile_tmp && mv ~/.bash_profile_tmp ~/.bash_profile

      grep -v 'export PYENV_ROOT="$HOME/.pyenv"' ~/.profile >~/.profile_tmp && mv ~/.profile_tmp ~/.profile
      grep -v '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' ~/.profile >~/.profile_tmp && mv ~/.profile_tmp ~/.profile
      grep -v 'eval "$(pyenv init -)"' ~/.profile >~/.profile_tmp && mv ~/.profile_tmp ~/.profile

      . ~/.bashrc

      echo -e "\033[32mPyenv uninstalled\033[0m\n"
    else
      echo -e "\033[36mPyenv not installed\033[0m\n"
    fi
  else
    echo "OS is Ubuntu but shell is not handle"
  fi
else
  echo "OS is not Ubuntu" && exit 1
fi

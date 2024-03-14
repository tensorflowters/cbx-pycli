#!/usr/bin/env bash

detect_shell() {
    CBX_VAR_SHELL=""
    CBX_VAR_SHELL_VERSION=""
    CBX_VAR_PARENT_SHELL=$(ps -p $$ -ocomm=)

    if [ -n "$SHELL" ]; then
        echo "Detected shell: $SHELL"
        echo "Version: $(echo $SHELL --version | head -n 1)"

        CBX_VAR_SHELL=$(which $SHELL)
        CBX_VAR_SHELL_VERSION=$(echo $($SHELL --version | head -n 1))

        return 0
    elif [ -n "$CBX_VAR_PARENT_SHELL" ]; then
        echo "Detected shell avec ps: $CBX_VAR_PARENT_SHELL"
        echo "Version: $(echo $($CBX_VAR_PARENT_SHELL --version | head -n 1))"
        CBX_VAR_SHELL=$(which $CBX_VAR_PARENT_SHELL)
        CBX_VAR_SHELL_VERSION=$(echo $($CBX_VAR_PARENT_SHELL --version | head -n 1))
        return 0
    elif [ -n "$BASH_VERSION" ]; then
        echo "Detected shell: Bash"
        echo "Version: $BASH_VERSION"
        CBX_VAR_SHELL=CBX_VAR_SHELL=$(which bash)
        CBX_VAR_SHELL_VERSION=$BASH_VERSION
        return 0
    elif [ -n "$ZSH_VERSION" ]; then
        echo "Detected shell: Zsh"
        echo "Version: $ZSH_VERSION"
        CBX_VAR_SHELL=$(which zsh)
        CBX_VAR_SHELL_VERSION=$ZSH_VERSION
        return 0
    elif [ -n "$KSH_VERSION" ] || [ -n "$FCEDIT" ]; then
        echo "Detected shell: Ksh"
        # KSH_VERSION n'est pas toujours disponible, FCEDIT est utilisé comme indicateur pour ksh93
        if [ -n "$KSH_VERSION" ]; then
            echo "Version: $KSH_VERSION"
            CBX_VAR_SHELL=$(which ksh)
            CBX_VAR_SHELL_VERSION=$KSH_VERSION
            return 0
        else
            echo "Version: ksh93 (Version exacte non disponible)"
            CBX_VAR_SHELL=$(which ksh)
            CBX_VAR_SHELL_VERSION="ksh93"
            return 0
        fi
    elif [ "$0" = "dash" ] || [ "$0" = "/bin/dash" ]; then
        echo "Detected shell: Dash"
        echo "Version: Not available"
        CBX_VAR_SHELL=$(which dash)
        CBX_VAR_SHELL_VERSION=$(dash --version | head -n 1 | awk '{print $2}')
        return 0
    elif [ -n "$FISH_VERSION" ]; then
        echo "Detected shell: Fish"
        echo "Version: $FISH_VERSION"
        CBX_VAR_SHELL=$(which fish)
        CBX_VAR_SHELL_VERSION=$FISH_VERSION
        return 0
    elif [ -n "$TCSH_VERSION" ]; then
        echo "Detected shell: Tcsh"
        echo "Version: $TCSH_VERSION"
        CBX_VAR_SHELL=$(which tcsh)
        CBX_VAR_SHELL_VERSION=$TCSH_VERSION
        return 0
    elif [ -n "$COLUMNS" ] && [ -z "$BASH_VERSION" ] && [ -z "$ZSH_VERSION" ]; then
        # Condition très basique pour csh, qui n'a pas de variable spécifique comme bash ou zsh
        echo "Detected shell: Csh ou un shell compatible"
        echo "Version: Not available"
        CBX_VAR_SHELL="Detected shell: Csh ou un shell compatible"
        CBX_VAR_SHELL_VERSION="Not available"
        exit 1
    else
        echo "Undetermined or unsupported shell"
        exit 1
    fi
}

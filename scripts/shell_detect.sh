#!/usr/bin/env bash

set -e

# Fonction pour détecter le shell courant et sa version
detect_shell() {
    shell_detected=""
    version=""
    # Utilisation de différentes variables pour déterminer le shell
    parent_shell=$(ps -p $$ -ocomm=)

    if [ -n "$SHELL" ]; then
        echo "Shell détecté: $SHELL"
        echo "Version: $(echo $SHELL --version | head -n 1)"
        shell_detected=$(which $SHELL)
        version=$(echo $($SHELL --version | head -n 1))
    elif [ -n "$parent_shell" ]; then
        echo "Shell détecté avec ps: $parent_shell"
        echo "Version: $(echo $($parent_shell --version | head -n 1))"
        shell_detected=$(which $parent_shell)
        version=$(echo $($parent_shell --version | head -n 1))
    elif [ -n "$BASH_VERSION" ]; then
        echo "Shell détecté: Bash"
        echo "Version: $BASH_VERSION"
        shell_detected=shell_detected=$(which bash)
        version=$BASH_VERSION
    elif [ -n "$ZSH_VERSION" ]; then
        echo "Shell détecté: Zsh"
        echo "Version: $ZSH_VERSION"
        shell_detected=$(which zsh)
        version=$ZSH_VERSION
    elif [ -n "$KSH_VERSION" ] || [ -n "$FCEDIT" ]; then
        echo "Shell détecté: Ksh"
        # KSH_VERSION n'est pas toujours disponible, FCEDIT est utilisé comme indicateur pour ksh93
        if [ -n "$KSH_VERSION" ]; then
            echo "Version: $KSH_VERSION"
            shell_detected=$(which ksh)
            version=$KSH_VERSION
        else
            echo "Version: ksh93 (Version exacte non disponible)"
            shell_detected=$(which ksh)
            version="ksh93"
        fi
    elif [ "$0" = "dash" ] || [ "$0" = "/bin/dash" ]; then
        # Dash ne fournit pas de variable pour sa version
        echo "Shell détecté: Dash"
        echo "Version: Non disponible"
        shell_detected=$(which dash)
        version=$(dash --version | head -n 1 | awk '{print $2}')
    elif [ -n "$FISH_VERSION" ]; then
        echo "Shell détecté: Fish"
        echo "Version: $FISH_VERSION"
        shell_detected=$(which fish)
        version=$FISH_VERSION
    elif [ -n "$TCSH_VERSION" ]; then
        echo "Shell détecté: Tcsh"
        echo "Version: $TCSH_VERSION"
        shell_detected=$(which tcsh)
        version=$TCSH_VERSION
    elif [ -n "$COLUMNS" ] && [ -z "$BASH_VERSION" ] && [ -z "$ZSH_VERSION" ]; then
        # Condition très basique pour csh, qui n'a pas de variable spécifique comme bash ou zsh
        echo "Shell détecté: Csh ou un shell compatible"
        echo "Version: Non disponible"
        shell_detected="Shell détecté: Csh ou un shell compatible"
        version="Non disponible"
    else
        echo "Shell inconnu ou non pris en charge"
    fi

    # Construction du JSON
    json_output="{\"shell\": \"${shell_detected}\", \"version\": \"${version}\"}"

    # Tentative de sauvegarde dans un fichier JSON
    echo $json_output | jq > scripts/shell_info.json
    chmod 777 shell_info.json
    chown $USER:$USER shell_info.json

    if [ $? -eq 0 ]; then
        echo "Informations du shell sauvegardées dans shell_info.json"
    else
        echo "Erreur lors de la sauvegarde des informations du shell"
    fi
}

# Appel de la fonction pour détecter le shell
detect_shell

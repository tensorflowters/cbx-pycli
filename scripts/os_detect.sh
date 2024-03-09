#!/usr/bin/env bash

set -e

detect_linux_distribution() {
    os_detected=""
    version=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "Distribution Linux détectée: $NAME"
        echo "Version: $VERSION"
        os_detected=$NAME
        version=$VERSION
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        echo "Distribution Linux détectée: $DISTRIB_ID"
        echo "Version: $DISTRIB_RELEASE"
        os_detected=$DISTRIB_ID
        version=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        echo "Distribution Linux détectée: Debian"
        echo "Version: $(cat /etc/debian_version)"
        os_detected=Debian
        version=$(cat /etc/debian_version)
    elif [ -f /etc/redhat-release ]; then
        echo "Distribution Linux détectée: $(cat /etc/redhat-release)"
        os_detected=$(cat /etc/redhat-release)
        version=$(cat /etc/redhat-release)
    else
        echo "Distribution Linux non détectée ou non prise en charge."
        os_detected="null"
        version="null"
        return 1
    fi

    # Construction du JSON
    json_output="{\"shell\": \"$os_detected\", \"version\": \"$version\"}"

    # Tentative de sauvegarde dans un fichier JSON
    echo $json_output >os_info.json
    chmod 777 os_info.json
    chown $USER:$USER os_info.json

    if [ $? -eq 0 ]; then
        echo "Informations du shell sauvegardées dans os_info.json"
        return 0
    else
        echo "Erreur lors de la sauvegarde des informations du os"
        return 1
    fi
}

# Détection de l'OS de base avec uname
os=$(uname -s)
case "$os" in
Linux*) os="Linux" ;;
Darwin*) os="Mac OS" ;;
CYGWIN*) os="Cygwin - Windows" ;;
MINGW*) os="MinGW - Windows" ;;
FreeBSD*) os="FreeBSD" ;;
NetBSD*) os="NetBSD" ;;
OpenBSD*) os="OpenBSD" ;;
SunOS*) os="Solaris" ;;
AIX*) os="AIX" ;;
*) os="Inconnu" ;;
esac
echo "Système d'exploitation détecté : $os"

# Détails supplémentaires pour Linux
if [ "$os" = "Linux" ]; then
    detect_linux_distribution
fi

# Détails pour BSD
if [[ "$os" == "FreeBSD" || "$os" == "NetBSD" || "$os" == "OpenBSD" ]]; then
    version=$(uname -r)
    echo "Version BSD détectée: $version"
    os_detected=$os
    version=$version
    # Construction du JSON
    json_output="{\"shell\": \"$os_detected\", \"version\": \"$version\"}"

    # Tentative de sauvegarde dans un fichier JSON
    echo $json_output >os_info.json
    chmod 777 os_info.json
    chown $USER:$USER os_info.json

    if [ $? -eq 0 ]; then
        echo "Informations du shell sauvegardées dans os_info.json"
        return 0
    else
        echo "Erreur lors de la sauvegarde des informations du os"
        return 1
    fi
fi

# Détails pour Solaris
if [ "$os" = "Solaris" ]; then
    version=$(uname -r)
    echo "Version Solaris détectée: $version"
    os_detected=$os
    version=$version
    # Construction du JSON
    json_output="{\"shell\": \"$os_detected\", \"version\": \"$version\"}"

    # Tentative de sauvegarde dans un fichier JSON
    echo $json_output | jq >os_info.json
    chmod 777 os_info.json
    chown $USER:$USER os_info.json

    if [ $? -eq 0 ]; then
        echo "Informations du shell sauvegardées dans os_info.json"
        return 0
    else
        echo "Erreur lors de la sauvegarde des informations du os"
        return 1
    fi
fi

# Détails pour Mac OS
if [ "$os" = "Mac OS" ]; then
    version=$(sw_vers -productVersion)
    echo "Version Mac OS détectée: $version"
    os_detected=$os
    version=$version
    # Construction du JSON
    json_output="{\"shell\": \"$os_detected\", \"version\": \"$version\"}"

    # Tentative de sauvegarde dans un fichier JSON
    echo $json_output >os_info.json
    chmod 777 os_info.json
    chown $USER:$USER os_info.json

    if [ $? -eq 0 ]; then
        echo "Informations du shell sauvegardées dans os_info.json"
        return 0
    else
        echo "Erreur lors de la sauvegarde des informations du os"
        return 1
    fi
fi

# Détails pour AIX
if [ "$os" = "AIX" ]; then
    version=$(oslevel)
    echo "Version AIX détectée: $version"
    os_detected=$os
    version=$version
    # Construction du JSON
    json_output="{\"OS\": \"$os_detected\", \"version\": \"$version\"}"

    # Tentative de sauvegarde dans un fichier JSON
    cat $json_output | jq >os_info.json
    chmod 777 os_info.json
    chown $USER:$USER os_info.json

    if [ $? -eq 0 ]; then
        echo "Informations du shell sauvegardées dans os_info.json"
    else
        echo "Erreur lors de la sauvegarde des informations du os"
    fi
fi

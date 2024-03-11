#!/usr/bin/env bash

detect_os () {
    # Détection de l'OS de base avec uname
    CBX_VAR_OS=$(uname -s)

    case "$CBX_VAR_OS" in
    Linux*) CBX_VAR_OS="Linux" ;;
    Darwin*) CBX_VAR_OS="Mac OS" ;;
    CYGWIN*) CBX_VAR_OS="Cygwin - Windows" ;;
    MINGW*) CBX_VAR_OS="MinGW - Windows" ;;
    FreeBSD*) CBX_VAR_OS="FreeBSD" ;;
    NetBSD*) CBX_VAR_OS="NetBSD" ;;
    OpenBSD*) CBX_VAR_OS="OpenBSD" ;;
    SunOS*) CBX_VAR_OS="Solaris" ;;
    AIX*) CBX_VAR_OS="AIX" ;;
    *) CBX_VAR_OS="Unknown" ;;
    esac

    if [ "$CBX_VAR_OS" = "Unknown" ]; then
        echo "Unknown operating system"
        exit 1
    fi

    echo "Operating System detected: $CBX_VAR_OS"

    if [ "$CBX_VAR_OS" = "Linux" ]; then
        CBX_VAR_DISTRIBUTION=""
        CBX_VAR_VERSION=""
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            echo "Linux distribution detected: $NAME"
            echo "Version: $VERSION"
            CBX_VAR_DISTRIBUTION=$NAME
            CBX_VAR_VERSION=$VERSION
            return 0
        elif [ -f /etc/lsb-release ]; then
            . /etc/lsb-release
            echo "Linux distribution detected: $DISTRIB_ID"
            echo "Version: $DISTRIB_RELEASE"
            CBX_VAR_DISTRIBUTION=$DISTRIB_ID
            CBX_VAR_VERSION=$DISTRIB_RELEASE
            return 0
        elif [ -f /etc/debian_version ]; then
            echo "Linux distribution detected: Debian"
            echo "Version: $(cat /etc/debian_version)"
            CBX_VAR_DISTRIBUTION=Debian
            CBX_VAR_VERSION=$(cat /etc/debian_version)
            return 0
        elif [ -f /etc/redhat-release ]; then
            echo "Linux distribution detected: $(cat /etc/redhat-release)"
            CBX_VAR_DISTRIBUTION=$(cat /etc/redhat-release)
            CBX_VAR_VERSION=$(cat /etc/redhat-release)
            return 0
        else
            echo "Unhandled Linux distribution"
            CBX_VAR_DISTRIBUTION="null"
            CBX_VAR_VERSION="null"
            exit 1
        fi
    else
        echo "OS not handled"
        exit 1
    fi
}
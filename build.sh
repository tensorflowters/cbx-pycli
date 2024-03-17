#! /usr/bin/env bash

set -e -x -v

current_build_location=$(pwd)
current_user=$(whoami)

mkdir -p .tmp
dpkg-deb --build . .tmp/cbx-cli.deb
chmod +xwr .tmp/cbx-cli.deb
chown ${current_user}:${current_user} .tmp/cbx-cli.deb
sudo dpkg -i --debug=2000 .tmp/cbx-cli.deb
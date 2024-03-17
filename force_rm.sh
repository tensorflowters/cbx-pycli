#! /usr/bin/env bash

sudo rm -rf /var/lib/dpkg/info/cbx-cli* | > /dev/null 2>&1
sudo rm -rf cbx-cli.deb | > /dev/null 2>&1
sudo rm -rf /var/lib/dpkg/tmp.ci/prerm/cbx* | > /dev/null 2>&1
sudo rm -rf /usr/bin/cbx-pycli | > /dev/null 2>&1

#!/bin/bash
set -xe -o pipefail
# Figure out what system we are running on
if [ -f /etc/lsb-release ];then
    . /etc/lsb-release
elif [ -f /etc/redhat-release ];then
    sudo yum install -y redhat-lsb
    DISTRIB_ID=`lsb_release -si`
    DISTRIB_RELEASE=`lsb_release -sr`
    DISTRIB_CODENAME=`lsb_release -sc`
    DISTRIB_DESCRIPTION=`lsb_release -sd`
fi
echo DISTRIB_ID: $DISTRIB_ID
echo DISTRIB_RELEASE: $DISTRIB_RELEASE
echo DISTRIB_CODENAME: $DISTRIB_CODENAME
echo DISTRIB_DESCRIPTION: $DISTRIB_DESCRIPTION

NSH_PLUGIN_DIR=$(dirname $0)/../../nsh-plugin
echo "NSH_PLUGIN_DIR: ${NSH_PLUGIN_DIR}"
cd ${NSH_PLUGIN_DIR}
autoreconf -i -f
mkdir _install
mkdir _build
cd _build
../configure --prefix=$(pwd)/../../_install
make
make install



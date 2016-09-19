#!/usr/bin/env bash
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
KERNEL_OS=`uname -o`
KERNEL_MACHINE=`uname -m`
KERNEL_RELEASE=`uname -r`
KERNEL_VERSION=`uname -v`

echo KERNEL_OS: $KERNEL_OS
echo KERNEL_MACHINE: $KERNEL_MACHINE
echo KERNEL_RELEASE: $KERNEL_RELEASE
echo KERNEL_VERSION: $KERNEL_VERSION
echo DISTRIB_ID: $DISTRIB_ID
echo DISTRIB_RELEASE: $DISTRIB_RELEASE
echo DISTRIB_CODENAME: $DISTRIB_CODENAME
echo DISTRIB_DESCRIPTION: $DISTRIB_DESCRIPTION

NSH_PLUGIN_DIR=$(dirname $0)
NSH_INSTALL_PREFIX=${NSH_INSTALL_PREFIX:-/usr}
cd ${NSH_PLUGIN_DIR}
autoreconf -i -f
[ -d build ] ||  mkdir build
[ -d ${NSH_INSTALL_PREFIX} ] || mkdir -p ${NSH_INSTALL_PREFIX}
cd build
../configure --prefix ${NSH_INSTALL_PREFIX}
if [ $DISTRIB_ID == "CentOS" ]; then
    echo "Start building rpms"
    make V=1 PATH=${PATH} pkg-rpm
    echo "Finished building rpms"
elif [ $DISTRIB_ID == "Ubuntu" ]; then
    echo "Start building debs"
    make V=1 PATH=${PATH} pkg-deb
    echo "Finished building debs"
else
    echo "Not packing.  Start make install"
    ${SUDOCMD-sudo} make PATH=${PATH} install
    echo "Not packing.  Finished make install"
fi


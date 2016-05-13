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

# Cleanup in case of installing vpp-dev and vpp-lib
echo "Cleaning up in case of vpp-dev and vpp-lib being installed"
if [ $DISTRIB_ID == "Ubuntu" ]; then
    sudo rm -f /etc/apt/sources.list.d/99fd.io.list
    sudo dpkg -r  vpp-dev vpp-lib vpp vpp-dpdk-dev vpp-dpdk-dkms vpp-dbg
elif [[ $DISTRIB_ID == "CentOS" ]]; then
    sudo rm -f /etc/yum.repos.d/fdio-master.repo
    sudo yum remove -y vpp-devel vpp-lib vpp
fi

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

NSH_PLUGIN_DIR=$(dirname $0)/../../nsh-plugin/
NSH_PLUGIN_DIR=$(readlink -f $NSH_PLUGIN_DIR)
echo "NSH_PLUGIN_DIR: ${NSH_PLUGIN_DIR}"
export NSH_INSTALL_PREFIX=${NSH_PLUGIN_DIR}/_install
export SUDOCMD=""
if test -f /usr/bin/lsb_release  && test `lsb_release -si` == "Ubuntu"  && test `lsb_release -sr` == "14.04"  && test -d /usr/lib/jvm/java-8-openjdk-amd64/ ; then
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
    export JAVAC=${JAVA_HOME}/bin/javac
    export PATH=${JAVA_HOME}/bin/:${PATH}
    break
fi
${NSH_PLUGIN_DIR}/build.sh
cd ${NSH_PLUGIN_DIR}/build/
if [ "${OS}" == "centos7" ]; then
    make pkg-rpm
fi


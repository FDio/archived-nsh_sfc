#!/bin/bash
set -e -o pipefail

#!/bin/bash
set -e -o pipefail

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

function setup {
    REPO_URL="${NEXUSPROXY}/content/repositories/fd.io.${REPO_NAME}"
    echo "REPO_URL: ${REPO_URL}"
    # Setup by installing vpp-dev and vpp-lib
    if [ $DISTRIB_ID == "Ubuntu" ]; then
        sudo rm -f /etc/apt/sources.list.d/99fd.io.list
        echo "deb ${REPO_URL} ./" | sudo tee /etc/apt/sources.list.d/99fd.io.list
        sudo apt-get update
        sudo apt-get -y remove vpp-dev vpp-lib
        sudo apt-get -y --force-yes install vpp-dev vpp-lib
    elif [[ $DISTRIB_ID == "CentOS" ]]; then
        sudo rm -f /etc/yum.repos.d/fdio-master.repo
        sudo cat << EOF > fdio-master.repo
[fdio-master]
name=fd.io master branch latest merge
baseurl=${REPO_URL}
enabled=1
gpgcheck=0
EOF
        sudo mv fdio-master.repo /etc/yum.repos.d/fdio-master.repo
        sudo yum -y remove vpp-devel vpp-lib
        sudo yum -y install vpp-devel vpp-lib
    fi
}

setup
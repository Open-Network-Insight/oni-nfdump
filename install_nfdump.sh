#!/bin/bash

dir=$1
install_path=${dir:-/opt/spot/bin}
dependencies=(tar make gcc m4 automake autoconf flex byacc)

log_cmd () {

    printf "\n****SPOT.NFDUMP.Install.sh****\n"
    date +"%y-%m-%d %H:%M:%S"
    printf "$1\n\n"

}

if [ ! -d ${install_path} ]; then
        log_cmd "${install_path} not created, override with 'install_nfdump.sh [optional path]'"
        exit 1   
fi

# detect distribution
# to add other distribution simply create a test case with installation commands

if [ -f /etc/redhat-release ]; then
    install_cmd="yum -y install"
    echo "installation command: $install_cmd"
elif [ -f /etc/debian_version ]; then
    install_cmd="apt-get install -y"
    echo "installation command: $install_cmd"
    apt-get update
fi


#########################################################
#--- dependencies ----------------------------------#
#########################################################

for dep in ${dependencies[@]}; do
    if type ${dep} >/dev/null 2>&1; then
        echo "${dep} found"
    else
        echo "installing ${dep}"
        ${install_cmd} ${dep}
    fi
done

#########################################################
#--- Install nfdump ----------------------------------#
#########################################################

cd nfdump
./configure --prefix=${install_path} --enable-sflow
make
make install

if type nfdump >/dev/null 2>&1; then
    echo "nfdump found"
else
    echo "ERROR: there was a problem with the nfdump installation"
    exit 1      
fi

cd ..

echo "Done !!!!!!!!!!!!!!!!!!!!!!!!"
nfdump -V

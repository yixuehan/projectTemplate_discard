#!/bin/bash

repo=~/projectTemplate

if [ -e '/etc/centos-release' ]
then
    MKOSTYPE=centos
    PYTHON=python3
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
fi
export MKOSTYPE

export OPENCL_INCLUDE_PATH=/opt/intel/opencl/include
export OPENCL_LIBRARY_PATH=/opt/intel/opencl

CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:${OPENCL_INCLUDE_PATH}
export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:~/usr/include:~/projectTemplate/util/cpp

export C_INCLUDE_PATH=${C_INCLUDE_PATH}:${CPLUS_INCLUDE_PATH}

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCL_LIBRARY_PATH}:~/usr/lib:~/usr/lib/boost

export LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/lib:/usr/lib64/mysql

export PATH=$PATH:${PRONAME}/bin:${HOME}/usr/bin:${PRONAME}/src/python/interface:${repo}/util/python

export PS1='[\u@\h \W]\$ '

export MKHOME=${repo}/mak
# export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages:${repo}/util/python:${HOME}/gencode
# export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages:${HOME}/gencode
export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages

export NUM_CPU=`cat /proc/cpuinfo | grep "processor" | wc -l`

export PKG_CONFIG_PATH=${HOME}/usr/lib/pkgconfig

#export MANPATH=/home/wangkai/project/thirdLib/${MKOSTYPE}/google_coredumper/man

alias cds='cd $PRONAME/src'
alias cdi='cd $PRONAME/include'
alias cdm='cd ${repo}/mak'
alias cde='cd ${repo}/env'
alias cdl='cd $PRONAME/log'
alias cdb='cd $PRONAME/bin'
alias cdp='cd $PRONAME'
alias cdlib='cd $PRONAME/lib'
alias cpmake='cp ${repo}/mak/build.sh . && chmod +x build.sh'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias docker++='docker run --rm -v${PWD}:/workdir -w/workdir w505703394/centos:dev g++ -std=c++2a -Wall'
alias g++='g++ -std=c++1z -Wall'
alias screen='screen -U'
# alias sconss='python3 $(which scons)'

function scons()
{
    python3 $(which scons)
}


function stop_docker()
{
    containers=$(docker ps -a | awk "NR > 1" | cut -d' ' -f1)
    echo ${containers}
    if [ "${containers}x" != "x" ]
    then
        echo ${containers} | xargs docker stop
    fi
}

function rm_docker()
{
    containers=$(docker ps -a | awk "NR > 1" | cut -d' ' -f1)
    echo ${containers}
    if [ "${containers}x" != "x" ]
    then
        echo ${containers} | xargs docker rm
    fi
}

function clean_dockeri()
{
    case $# in
    0)
        images=$(docker images | grep "<none>" | awk '{print $3}')
        if [ "${images}x" == "x" ]
        then
            echo "nothing to do"
            return 0
        fi
        docker rmi ${images}
        ;;
    *)
        # shift
        for arg in $*
        do
            docker rmi $(docker images|grep ${arg}|awk '{printf "%s:%s\n", $1,$2}')
        done
        ;;
    esac
}

function cd()
{
    builtin cd $@ && ls
}

# function vimcpp()
# {
#     ln -s ${repo}/cpp.vimrc ~/.vimrc -f
# }
# 
# function vimgo()
# {
#     ln -s ${repo}/go.vimrc ~/.vimrc -f
# }
# 
# unalias vi 2>/dev/null
# unalias vim 2>/dev/null
# 
# function vi()
# {
#     f=$1
#     _vi=`which vi`
#     if [ $MKOSTYPE = 'centos' ]
#     then
#         ${_vi} $@
#         return $?
#     fi
#     case ${f##*.} in
#         go) 
#             ln -s ${repo}/go.vimrc ~/.vimrc -f
#             ;;
#         h|hpp|cpp|c|ipp) 
#             ln -s ${repo}/cpp.vimrc ~/.vimrc -f
#             ;;
#         *)
#             ln -s ${repo}/cpp.vimrc ~/.vimrc -f
#             ;;
#     esac
#     ${_vi} $@
# }
# 
# function vim()
# {
#     vi $@
# }

ulimit -c unlimited

# devtoolset-7
if [ $MKOSTYPE = "centos" ]
then
    #export PATH=/opt/rh/devtoolset-7/root/bin:$PATH
    #export PATH=/opt/rh/rh-python36/root/bin:$PATH
    source /opt/rh/devtoolset-8/enable
    # source /opt/rh/rh-python36/enable
    source /opt/rh/rh-mysql80/enable
    # scl enable devtoolset-7 bash
fi

#if [ 4 -eq $SHLVL ] && [ $MKOSTYPE = "centos" ]
#then
#    scl enable rh-${PYTHON} bash
#fi

which ccache &> /dev/null
if [ 0 -eq $? ]
then
    export CCACHE_DIR=/tmp/${USER}/ccache
    ccache --max-size=10G > /dev/null
    export CCACHE_SIZE=10G # redundant; set anyway
    export CCACHE_UMASK=0 # shared to world
fi
export PKG_CONFIG_PATH=${HOME}/usr/lib/pkgconfig

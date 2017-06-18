#!/bin/bash
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -6)
        VERSION=6
        NODE_VERSION="6.11.0"
        ;;
        -8)
        VERSION=8
        NODE_VERSION="8.1.2"
        ;;
        *)
        echo "Unknown option '$key'"
        exit 2;
        ;;
    esac
    shift
done
if  [[ "$VERSION" = "" ]]; then
    echo "Please select VERSION:"
    echo "       ./build -6"
    echo "       ./build -8"
    exit 2
fi

# Always remove and refresh
[[ -d  /srv/docker/nodejs-official/docker-node ]] &&  \
  rm -rf /srv/docker/nodejs-official/docker-node

cd /srv/docker/nodejs-official/
git clone https://github.com/nodejs/docker-node.git
patch -p0 < docker-node.patch
if [[ "$(docker images -q whw3/alpine 2> /dev/null)" == "" ]]; then
    if [[ ! -d /srv/docker/alpine ]]; then
        cd /srv/docker/
        git@git:Docker/alpine.git
    fi
    cd /srv/docker/alpine
    /srv/docker/alpine/build.sh
fi
if [ "$VERSION" = "6" ]; then 
    cd /srv/docker/nodejs-official/docker-node/6.11/alpine/
else
    cd /srv/docker/nodejs-official/docker-node/8.1/alpine/
fi
docker build -t whw3/alpine-node:$NODE_VERSION .

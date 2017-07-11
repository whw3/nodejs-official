#!/bin/bash
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -6)
        VERSION=6
        ;;
        -8)
        VERSION=8
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
        git clone https://github.com/whw3/alpine.git
    fi
    cd /srv/docker/alpine
    /srv/docker/alpine/build.sh
fi
if [ "$VERSION" = "6" ]; then 
    cd /srv/docker/nodejs-official/docker-node/6.11/alpine/
else
    cd /srv/docker/nodejs-official/docker-node/8.1/alpine/
fi

grep NODE_VERSION Dockerfile| sed -e 's/ENV/export/;s/$/"/;s/VERSION /VERSION="/' > /srv/docker/nodejs-official/NODE_VERSION
source /srv/docker/nodejs-official/NODE_VERSION
RELEASE=$(echo NODE_VERSION | sed 's/\.[0-9]\+$//')
cat << EOF > options 
export RELEASE="v$RELEASE"
export TAGS=(whw3/alpine-node:$RELEASE whw3/alpine-node:latest)
EOF

docker build -t whw3/alpine-node .

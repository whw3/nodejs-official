# nodejs-official
Official NodeJS docker image adapted for use with Raspberry Pi

### Assumptions
* home for docker build images is ***/srv/docker***

To build the docker image run ***/srv/docker/nodejs-official/build.sh***
```
mkdir -p /srv/docker
cd /srv/docker
git clone https://github.com/whw3/nodejs-official.git
cd nodejs-official
chmod 0700 build.sh
./build.sh -8
```

#### Be warned this is a LONG build.

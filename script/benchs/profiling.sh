#!/bin/sh
# Small script to profile traefik generating a bunch of containers
# As arguments it takes a binary (traefik), a config file path.

set -e

TRAEFIK_BIN=$1
shift
TRAEFIK_CONFIG=$1
shift

docker pull nginx

echo "> Start traefik"
$TRAEFIK_BIN --configFile $TRAEFIK_CONFIG >./traefik.log 2>./traefik.err.log & tpid=$!

for elt in $(seq 1 100); do
    docker run -d --label=traefik.port=80 --label=traefik.test=true --label=traefik.backend=toto --name=toto-1-${elt} nginx
    docker run -d --label=traefik.port=80 --label=traefik.test=true --label=traefik.backend=titi --name=toto-2-${elt} nginx
    sleep 3
done

kill -15 $tpid

docker kill $(docker ps -a --filter label=traefik.test -q) || true
docker rm $(docker ps -a --filter label=traefik.test -q) || true

exit 0

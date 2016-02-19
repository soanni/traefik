#!/bin/sh
set -e

go get github.com/tcnksm/ghr
ghr -t $GITHUB_TOKEN -u emilevauge -r traefik --prerelease ${VERSION} dist/
docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
docker push ${REPO,,}:latest
docker tag ${REPO,,}:latest ${REPO,,}:${VERSION}
docker push ${REPO,,}:${VERSION}

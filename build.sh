#!/bin/bash

DOCKER_PROXY_DEBUG=1

if [[ DOCKER_PROXY_DEBUG -eq 1 ]] ; then
    IMAGE_SUFFIX='-debug'
else
    IMAGE_SUFFIX=''
fi

# Get the versions of alpine and nginx from the Dockerfile and use those to create the build tag.
ALPINE_VER=$(cat Dockerfile |grep 'FROM alpine:' | cut -d: -f2)
NGINX_VER=$(cat Dockerfile |grep 'ENV NGINX_VERSION' | awk '{print $3}')
IMAGE_NAME="nginx-proxy-connect-stable-alpine:nginx-${NGINX_VER}-alpine-${ALPINE_VER}${IMAGE_SUFFIX}"

# Tweak this to toggle debug builds
docker build --build-arg DEBUG_BUILD=1 -t $IMAGE_NAME .

exit 0

docker run -it --rm $IMAGE_NAME -e DEBUG_NGINX=true -e DEBUG=true -e DEBUG_HUB=true


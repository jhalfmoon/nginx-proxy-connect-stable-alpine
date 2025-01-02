#!/bin/bash -eux

# This script is mainly meant to help develop / debug this image build

DOCKER_PROXY_DEBUG=1

if [[ DOCKER_PROXY_DEBUG -eq 1 ]] ; then
    IMAGE_SUFFIX='-debug'
else
    IMAGE_SUFFIX=''
fi

# Get the versions of alpine and nginx from the Dockerfile and use those to create the build tag.
ALPINE_VER=$(cat Dockerfile |grep 'FROM alpine:' | cut -d: -f2)
NGINX_VER=$(cat Dockerfile |grep 'ENV NGINX_VERSION' | tr '=' ' ' | awk '{print $3}')
IMAGE_NAME="nginx-proxy-connect-stable-alpine:nginx-${NGINX_VER}-alpine-${ALPINE_VER}${IMAGE_SUFFIX}"

# You might want to cleanup now and then. Caches can eat up quite alot of storage.
# This is also useful for debugging / testing build times.
#
# docker builder prune --all --force

time docker build \
    --progress=plain \
    --build-arg DEBUG_BUILD=1 \
    -t $IMAGE_NAME \
    .

exit 0

# Example
docker run \
    -it \
    --rm $IMAGE_NAME \
    -e DEBUG_NGINX=true \
    -e DEBUG_HUB=true
    -e DEBUG=true


#!/bin/bash

# Get the versions of alpine and nginx from the Dockerfile and use those to create the build tag.
ALPINE_VER=$(cat Dockerfile |grep 'FROM alpine:' | cut -d: -f2)
NGINX_VER=$(cat Dockerfile |grep 'ENV NGINX_VERSION' | awk '{print $3}')
IMAGE_NAME="nginx-proxy-connect-stable-alpine:nginx-${NGINX_VER}-alpine-${ALPINE_VER}"

# Tweak this to toggle debug builds
docker build --build-arg DEBUG_BUILD=1 -t $IMAGE_NAME .


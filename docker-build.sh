#!/bin/bash
TAG=$1
PLATFORM=$2

# build images
docker compose --env-file .env.$TAG build --build-arg PLATFORM=$PLATFORM php-fpm workspace

#push to dockerhub
docker push $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG-$PLATFORM

#create multiarch manifest
docker manifest create $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG \
--amend $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG-amd64 \
--amend $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG-arm64

#push to dockerhub
docker manifest push --purge $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG

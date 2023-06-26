#!/bin/bash
TAG=$1
PLATFORM=$2

# build images
echo "building image"
cat .env.$TAG > .temp
echo "PLATFORM=$2" >> .temp
docker compose --env-file .temp build php-fpm workspace
rm .temp

#push to dockerhub
echo "pushing to dockerhub"
docker push "$ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG-$PLATFORM"
docker push "$ORGANIZATION/$COMPOSE_PROJECT_NAME-workspace:$TAG-$PLATFORM"

#create multiarch manifest
echo "creating shared manifest"
docker manifest create $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG \
    $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG-$PLATFORM
docker manifest create $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG \
    $ORGANIZATION/$COMPOSE_PROJECT_NAME-workspace:$TAG-$PLATFORM

#push to dockerhub
echo "pushing shared manifest to dockerhub"
docker manifest push --purge $ORGANIZATION/$COMPOSE_PROJECT_NAME-php-fpm:$TAG
docker manifest push --purge $ORGANIZATION/$COMPOSE_PROJECT_NAME-workspace:$TAG

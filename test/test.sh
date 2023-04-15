#!/usr/local/env sh

docker build -t podsh . 
docker run --entrypoint tar --rm -ti podsh -h

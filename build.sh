#!/usr/bin/env bash

export JEKYLL_VERSION=2.5.3
docker run --rm \
  --volume="$PWD:/srv/jekyll" \
  -it jekyll/jekyll:$JEKYLL_VERSION \
  jekyll build

docker build -t konrness/konrness.com .
#!/usr/bin/env bash

bundle exec jekyll build
scp -r _site/* venus@konrness.com:/vweb/konrness.com/docs/
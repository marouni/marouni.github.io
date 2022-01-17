#!/bin/bash

bundle exec jekyll clean && bundle exec jekyll build

rsync --times --verbose --recursive _site/* server2:/home/abbass/sources/blog/

#!/bin/bash

bundle3.0 exec jekyll clean && bundle3.0 exec jekyll build

bundle3.0 exec jekyll build && bash -c 'cd _site && python -m http.server 3000'

rsync --times --verbose --recursive _site/* server2:/home/abbass/sources/blog/

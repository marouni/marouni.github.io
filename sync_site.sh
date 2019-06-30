#!/bin/bash

rsync --times --verbose --recursive _site/* server2:/home/abbass/sources/blog/

#!/bin/bash
DIR_OF_THIS_FILE=$(cd $(dirname $0); pwd)/
docker run --rm -it -v $DIR_OF_THIS_FILE:/workspace -w /workspace ubuntu:20.04

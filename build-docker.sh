#!/usr/bin/env sh

docker build -t PLACEHOLDER/mxd-performance-test:0.1.2-SNAPSHOT .

docker image push PLACEHOLDER/mxd-performance-test:0.1.2-SNAPSHOT
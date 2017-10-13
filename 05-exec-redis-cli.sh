#!/bin/bash -x

source cfg.inc

docker exec -it $DNAME redis-cli -p 7000

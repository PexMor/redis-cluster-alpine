#!/bin/bash -x

source cfg.inc

PORTS="-p 7000:7000 -p 7001:7001 -p 7002:7002 -p 7003:7003 -p 7004:7004 -p 7005:7005 -p 7006:7006 -p 7007:7007"

docker run -d ${PORTS} --name $DNAME --hostname $DNAME $INAME


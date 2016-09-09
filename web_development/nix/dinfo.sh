#!/bin/sh

DISC=$1
PARTITION=`df -h |grep $DISC|awk '{print $1}'`
SIZE=`df -h|grep $DISC|awk '{print $2}'`
USED=`df -h|grep $DISC|awk '{print $3}'`
FREE=`df -h|grep $DISC|awk '{print $4}'`

echo Partition: $PARTITION
echo Total size: $SIZE
echo Used space: $USED
echo Free space: $FREE

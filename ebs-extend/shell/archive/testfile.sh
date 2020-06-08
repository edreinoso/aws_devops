#!/bin/bash

volumePath='ebs'


#NOTE: fstab input has got to be standarized.
#Otherwise, it is not going to work
typeOfVolume=`cat ./fstab.txt | grep /$volumePath |  cut -d " " -f 5`

if [ $typeOfVolume == "xfs" ]; then
  echo "Hello"
  #xfs_growfs -d /$volumePath
else
  echo "World"
  #resize2fs /dev/xvda1
fi
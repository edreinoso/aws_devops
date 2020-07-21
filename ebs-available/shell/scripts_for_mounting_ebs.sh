#!/bin/bash
#initializing important variables
device={{device}}
logic=true
value="data"
n=0

file -s $device # Rajesh has this part of the script. There should be an if statement here
mkfs -t xfs $device

while [ "$logic" != "false" ]
do
    x=`ls / | grep $value`
    # mkdir
    if [[ -z  $x ]]; then
        mkdir /$value
        logic=false
    else
        ((n+=1)) #sum operations
        value="data"
        value="$value$n" # assigning new value
    fi
done

mount $device /$value
cp /etc/fstab /etc/fstab.orig

# there is another piece of logic to be done here
# have to strip the shit out of this
blkid=`blkid -o value -s UUID $device` # Rajesh also has this part of the script
# would XFS have to be constant or a variable?
# would the number 2 have to auto increase?
UUID=`$blkid  /$value  xfs  defaults,nofail  0  2`
cat $UUID >> fstab

umount /$value
mount -a
#!/bin/bash
#initializing important variables
device={{device}}
logic=true
value="data"
n=0

# first volume is taken care by Amazon
if [ "$device" != "/dev/xvda" ]; then # this would avoid going for the first volume that's created
    file -s $device
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
    
    echo $device /$value >> /home/ec2-user/test.txt
    mount $device /$value
    
    cp /etc/fstab /etc/fstab.orig
    blkid=`blkid -o value -s UUID $device`
    echo $blkid >> /home/ec2-user/test.txt
    UUID=`$blkid  /$value  xfs  defaults,nofail  0  2`
    echo $UUID >> /etc/fstab
    
    echo >> /home/ec2-user/test.txt
fi
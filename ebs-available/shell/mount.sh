device="/dev/xvdk"
value="/data"

# sudo mount $device /$value >> /home/ec2-user/test1.txt
# sudo cp /etc/fstab /etc/fstab.orig
blkid=`blkid -o value -s UUID $device`
echo $blkid
echo $blkid >> /home/ec2-user/test1.txt
# UUID=`$blkid  /$value  xfs  defaults,nofail  0  2`
# sudo cat $UUID >> /etc/fstab
# sudo umount /$value
# sudo mount -a
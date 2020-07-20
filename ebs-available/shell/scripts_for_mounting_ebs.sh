#variables
#/dev/xvdX # could be got from device in lambda python
#directory also has to be dynamic in a sense. /data 

sudo file -s /dev/xvda1
sudo mkfs -t xfs /dev/xvdf
sudo mkdir /data
sudo mount /dev/xvdf /data
sudo cp /etc/fstab /etc/fstab.orig
sudo blkid
UUID=aebf131c-6957-451e-8d34-ec978d9581ae  /data  xfs  defaults,nofail  0  2
sudo umount /data
sudo mount -a
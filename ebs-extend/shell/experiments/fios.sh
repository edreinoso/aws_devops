timestamp=`date +%Y-%m-%d_%H:%M:%S`

sudo fio --directory=/data --name $timestamp"_testing_file" --direct=0 --rw=randwrite --bs=4k --size=512M --numjobs=2 --time_based --runtime=180 --group_reporting

sudo fio --directory=/data \
  --name hello_world_4 \
  --direct=0 \
  --rw=randwrite \
  --bs=4k \
  --size=512M \
  --numjobs=2 \
  --time_based \
  --runtime=180 \
  --group_reporting

# This command will write a total 4GB file [4 jobs x 512 MB = 2GB] running 2 processes at a time:

sudo fio --directory=/ebs/partition1 \
  --name=testing_randwrite \
  --ioengine=libaio \
  --iodepth=1 \
  --rw=randwrite \
  --bs=4k \
  --direct=0 \
  --size=512M \
  --numjobs=2 \
  --runtime=180 \
  --group_reporting


sudo fio --directory=/mnt/p_iops_vol0 \
  --name fio_test_file \
  --direct=1 \
  --rw=randwrite \
  --bs=16k \
  --size=1G \
  --numjobs=16 \
  --time_based \
  --runtime=180 \
  --group_reporting \
  --norandommap

# ~/aws-scripts-mon/mon-put-instance-data.pl --disk-path=/test --disk-space-util --verbose
# ~/aws-scripts-mon/mon-put-instance-data.pl --disk-path=/test --disk-space-used --verbose
# ~/aws-scripts-mon/mon-put-instance-data.pl --disk-path=/test --disk-space-avail --verbose
netstat -i
/sbin/ifconfig -a
ip addr li
ip link show

cat /etc/*release
route -n
ifconfig
ping -c 3 10.0.1.57 
ping -c 3 10.0.1.43
ping -c 3 10.0.1.15 
ping -c 3 10.0.1.28


default via 10.0.0.1 dev eth1 table 2
10.0.0.0/24 dev eth1 src 10.0.0.10 table 2

# 17th of march
10.0.1.0/24 dev eth0 src 10.0.1.22 table 1
default via 10.0.1.1 dev eth0 table 1

10.0.1.0/24 dev ens3 src 10.0.1.8 table 2
default via 10.0.1.1 dev ens3 table 2

from 10.0.1.22/32 table 1
from 10.0.1.8/32 table 2


# 18th of march
10.0.1.0/24 dev eth0 src 10.0.1.15 table 1
default via 10.0.1.1 dev eth0 table 1

10.0.1.0/24 dev eth1 src 10.0.1.28 table 2
default via 10.0.1.1 dev eth1 table 2

from 10.0.1.15/32 table 1
from 10.0.1.28/32 table 2


# 2nd of august
sudo ip rule add from 10.0.1.47/32 lookup 100
sudo ip rule add from 10.0.1.41/32 lookup 200

# default via 10.0.0.1 dev eth0 table 100
sudo ip route add default via 10.0.1.33 dev eth0 table 100
sudo ip route add default via 10.0.1.33 dev eth1 table 200

sudo ip rule delete from 10.0.1.47/32 lookup 100
sudo ip rule delete from 10.0.1.41/32 lookup 200

sudo ip route delete 10.0.1.0/27 dev eth0 tab 100
sudo ip route delete 10.0.1.0/27 dev eth1 tab 200
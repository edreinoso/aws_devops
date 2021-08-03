#!/bin/bash

eni0='{{NetworkInterface0}}'
eni1='{{NetworkInterface1}}'
gw=`route -n | grep 'UG[ \t]' | awk '{print $2}'`

echo $eni0 $eni1 $gw >> /home/centos/networkInterfaces.txt

# creates the configuration for the network interface
cat >> /etc/sysconfig/network-scripts/ifcfg-eth1 <<EOF
DEVICE="eth1"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
DEFROUTE="no"
EOF

# this commands restarts teh network config in instance
systemctl restart network.service

sleep 10

# perform the necessary routing changes
ip rule add from $eni0/32 lookup 100
ip rule add from $eni1/32 lookup 200

ip route add default via $gw dev eth0 table 100
ip route add default via $gw dev eth1 table 200

# persisting changes
echo "from $eni0/32 lookup 100" >> /etc/sysconfig/network-scripts/rule-eth0
echo "default via $gw dev eth0 table 100" >> /etc/sysconfig/network-scripts/route-eth0

echo "from $eni1/32 lookup 200" >> /etc/sysconfig/network-scripts/rule-eth1
echo "default via $gw dev eth1 table 200" >> /etc/sysconfig/network-scripts/route-eth1
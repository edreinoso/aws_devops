#!/bin/bash
# this file needs to be seriously modified!

# 1st
retrieve the number of eth in host

# 2nd
add +1 to the ethX


# there was a way of getting these network interfaces with some commands
gw=`route -n | grep 'UG[ \t]' | awk '{print $2}'`



# creates the configuration for the network interface
cat >> /etc/sysconfig/network-scripts/ifcfg-ethX <<EOF
DEVICE="ethX"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
DEFROUTE="no"
EOF


# 3rd restart network
# this commands restarts teh network config in instance
systemctl restart network.service

# get the status

sleep 10 # there is a possibility here where restarting the network service might take longer. However, currently this is static and might need some improvements



eniX=`hostname -I | awk '{print $X}'`

eniX -- X + 100
eni1 -- 100
eni2 -- 200
eni3 -- 300

# perform the necessary routing changes
ip rule add from $eniX/32 lookup X
ip route add default via $gw dev ethX table X

# persisting changes
echo "from $eniX/32 lookup X" >> /etc/sysconfig/network-scripts/rule-ethX
echo "default via $gw dev ethX table X" >> /etc/sysconfig/network-scripts/route-ethX
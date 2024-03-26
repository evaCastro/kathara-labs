#!/bin/sh

tc qdisc del dev eth0 ingress 2> /dev/null

echo "Adding ingress qdisc"
tc qdisc add dev eth0 handle ffff: ingress

tc filter add dev eth0 parent ffff: \
    protocol ip prio 4 u32 \
    match ip src 12.0.0.30/32 \
    match ip dst 16.0.0.60/32 \
    match ip tos 0x68 0xff \
    police rate 500kbit burst 10k drop flowid :5

tc filter add dev eth0 parent ffff: \
    protocol ip prio 5 u32 \
    match ip src 12.0.0.30/32 \
    match ip dst 16.0.0.60/32 \
    match ip tos 0x48 0xff \
    police rate 300kbit burst 10k drop flowid :6


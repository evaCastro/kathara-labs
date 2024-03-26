#!/bin/sh

tc qdisc del dev eth0 ingress 2> /dev/null

echo "Adding ingress qdisc"
tc qdisc add dev eth0 handle ffff: ingress

tc filter add dev eth0 parent ffff: \
    protocol ip prio 4 u32 \
    match ip src 11.0.0.10/32 \
    match ip dst 16.0.0.40/32 \
    match ip tos 0x88 0xff \
    police rate 1mbit burst 10k drop flowid :1

tc filter add dev eth0 parent ffff: \
    protocol ip prio 5 u32 \
    match ip src 11.0.0.10/32 \
    match ip dst 16.0.0.40/32 \
    match ip tos 0x68 0xff \
    police rate 400kbit burst 10k drop flowid :2

tc filter add dev eth0 parent ffff: \
    protocol ip prio 4 u32 \
    match ip src 11.0.0.20/32 \
    match ip dst 16.0.0.50/32 \
    match ip tos 0x48 0xff \
    police rate 600kbit burst 10k drop flowid :3

tc filter add dev eth0 parent ffff: \
    protocol ip prio 5 u32 \
    match ip src 11.0.0.20/32 \
    match ip dst 16.0.0.50/32 \
    match ip tos 0x28 0xff \
    police rate 100kbit burst 10k drop flowid :4


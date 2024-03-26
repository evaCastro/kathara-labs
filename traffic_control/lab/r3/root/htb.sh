#!/bin/sh

tc qdisc del dev eth2 root 2> /dev/null


echo "Adding htb qdisc..."

tc qdisc add dev eth2 root handle 2:0 htb

tc class add dev eth2 parent 2:0 classid 2:1 htb rate 2.2mbit

# 2Mbit from 11.0.0.0/24 -> 1.4Mbit from pc1 and 600 from pc2
# 8kbit from pc3 
# TOTAL -> 2.2Mbit

# AF41: received 1Mbit
tc class add dev eth2 parent 2:1 classid 2:11 htb rate 1mbit ceil 2.2mbit

# AF31: received 400kbit + 500kbit = 900 kbit
tc class add dev eth2 parent 2:1 classid 2:12 htb rate 500kbit ceil 2.2mbit

# AF21 600kbita + 500kbit + 300kbit = 800 knit
tc class add dev eth2 parent 2:1 classid 2:13 htb rate 600kbit ceil 2.2mbit

#AF11 100kbit = 100 kbit
tc class add dev eth2 parent 2:1 classid 2:14 htb rate 100kbit ceil 2.2mbit


tc filter add dev eth2 parent 2:0 protocol ip prio 1 u32 \
    match ip tos 0x88 0xff \
    flowid 2:11

tc filter add dev eth2 parent 2:0 protocol ip prio 2 u32 \
    match ip tos 0x68 0xff \
    flowid 2:12

tc filter add dev eth2 parent 2:0 protocol ip prio 3 u32 \
    match ip tos 0x48 0xff \
    flowid 2:13

tc filter add dev eth2 parent 2:0 protocol ip prio 4 u32 \
    match ip tos 0x28 0xff \
    flowid 2:14


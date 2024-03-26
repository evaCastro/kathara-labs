## Configuration for Kathará traffic control scenario:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/traffic_control/images/tc_lab.png"
     alt="Traffic control"
     style="float: left; margin-right: 10px;" width=700 />

### Two iperf server2 at pc4, pc5, pc6 (ports 5001 and 5002)
    iperf3 -s -p 5001 &
    iperf3 -s -p 5002 &

### Script to send traffic from pc1 -> pc4 (/root/iperf-client.sh)
2Mbit DS=0x88 to pc4 port 5001 -> AF41 
    iperf3 -c 16.0.0.40 -p 5001 -i 1 -u -b 2M -S 0x88 &

1Mbit DS=0x68 to pc4 port 5002 -> AF31 
    iperf3 -c 16.0.0.40 -p 5002 -i 1 -u -b 1M -S 0x68 &

### Script to send traffic from pc2 -> pc5 (/root/iperf-client.sh)
2Mbit DS=0x48 to pc5 port 5001 -> AF21 
    iperf3 -c 16.0.0.50 -p 5001 -i 1 -u -b 2M -S 0x48 &
    
1Mbit DS=0x28 to pc5 port 5002 -> AF11 
    iperf3 -c 16.0.0.50 -p 5002 -i 1 -u -b 1M -S 0x28 &

### Script to send traffic from pc3 -> pc6 (/root/iperf-client.sh)
2Mbit DS=0x48 to pc6 port 5001 -> AF31 
    iperf3 -c 16.0.0.60 -p 5001 -i 1 -u -b 2M -S 0x68 &

1Mbit DS=0x28 to pc6 port 5002 -> AF21 
    iperf3 -c 16.0.0.60 -p 5002 -i 1 -u -b 1M -S 0x48 &
    
### Ingress policy qdisc at r1
Limit traffic from pc1 and pc2
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

### Ingress policy qdisc at r2
Limit traffic from pc3
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


### Root htb qdisc at r3

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

    # AF21 600kbita + 500kbit + 300kbit = 800 kbit
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

### pcap
Captured traffic at r3(eth2) <a href="https://github.com/evaCastro/kathara-labs/blob/main/traffic_control/pcap/r3-eth2.pcap">r2-eth2.pcap</a>. See flows:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/traffic_control/images/flows.png"
     alt="Flows"
     style="float: left; margin-right: 10px;" width=700 />

#/bin/bash

iperf3 -c 16.0.0.40 -p 5001 -i 1 -u -b 2M -S 0x88 &
iperf3 -c 16.0.0.40 -p 5002 -i 1 -u -b 1M -S 0x68 &

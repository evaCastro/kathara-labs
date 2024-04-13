## Configuration for Kathará TCP scenario using fast open:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/tcp_fto/images/TCP.png"
     alt="TCP config"
     style="float: left; margin-right: 10px;" width=700 />


### TCP Server
   - pc2

### TCP Client
   - pc1


## Capture files:
   - Capture file <a href="https://github.com/evaCastro/kathara-labs/blob/main/tcp_fto/pcaps/tcp_fto.pcap">tcp_fto.pcap</a>.
         - From pc2: python3 server.py: TCP echo server at port 9000
         - From pc1: python3 client.py: TCP echo client connects to pc2:9000
     

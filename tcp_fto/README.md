## Configuration for Kathará TCP scenario using fast open:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/tcp_fto/images/tcp.png"
     alt="TCP config"
     style="float: left; margin-right: 10px;" width=700 />

There is a TCP echo server at `pc2` (/root/server.py) and a TCP echo client at  `pc1` (/root/client.py). Both files from https://superuser.blog/tcp-fast-open-python.

`pc1` and `pc2` are configured using:

     sysctl -w net.ipv4.tcp_fastopen=3




## Capture files:

   - Capture file <a href="https://github.com/evaCastro/kathara-labs/blob/main/tcp_fto/pcaps/tcp_fto.pcap">tcp_fto.pcap</a>
   
         - From pc2: `python3 /root/server.py`: TCP echo server at port 9000
         - From pc1: `python3 /root/client.py`: TCP echo client connects to pc2:9000

     <img src="https://github.com/evaCastro/kathara-labs/blob/main/tcp_fto/images/capture.png"
     alt="TCP capture file"
     style="float: left; margin-right: 10px;" width=700 />

     <img src="https://github.com/evaCastro/kathara-labs/blob/main/tcp_fto/images/flow_graph.png"
     alt="TCP flow graph"
     style="float: left; margin-right: 10px;" width=700 />
     

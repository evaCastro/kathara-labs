## Configuration for Kathará DNS scenario:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/dns/images/dns.png"
     alt="DNS servers"
     style="float: left; margin-right: 10px;" width=700 />


### DNS servers
   - Root servers: dnsroot1 and dnsroot2
   - com. domain: dnscom. r1, r2 and dnscom belong to dnscom domain.
   - net. domain: dnsnet. r3, r4 and dnsnet belong to dnsnet domain.
   - emp1.com. domain: dnsemp1. pc1 an dnsemp1 belong to dnsemp1 domain.
   - emp2.net. domain: dnsemp2. pc2 an dnsemp2 belong to dnsemp2 domain.

### DNS sever for each pc/router
   - dnscom: r1, r2 and dnscom are configured to use dnscom as DNS server.
   - dnsnet: r3, r4 and dnscom are configured to use dnsnet as DNS server.
   - dnsemp1: pc1 and dnsemp1 are configured to use dnsemp1 as DNS server.
   - dnsemp2: pc2 and dnsemp2 are configured to use dnsemp2 as DNS server.

## Capture files:
   - Capture file <a href="https://github.com/evaCastro/kathara-labs/blob/main/dns/pcaps/dns1.pcap">dns1.pcap</a>. From pc1:
         - nslookup -type=A pc2.emp2.net 

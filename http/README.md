## Configuration for Kathará HTTP scenario:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/http/images/http.png"
     alt="HTTP server"
     style="float: left; margin-right: 10px;" width=700 />

This Kathará laboratory uses the same DNS configuration of [DNS-lab](https://github.com/evaCastro/kathara-labs/blob/main/dns).

### HTTP server
   - pc2.emp2.net is running Apache server, port 80.

### Proxy server
   - r1.com is running Proxy Apache server, port 8080.

### HTTP client 
   - From pc1: `wget -m http://pc2.emp2.net/index.html`
   - See the capture file: [HTTP.pcap](https://github.com/evaCastro/kathara-labs/blob/main/http/pcap/HTTP.pcap)
  
### HTTP client through proxy
   - From pc1: 
       - Edit file: `/root/.wgetrc` and uncomment the following line:
             `http_proxy=http://12.0.0.1:8080`
       - `wget -m http://pc2.emp2.net/index.html`
   - See the capture files: 
       - From pc1: [HTTP-proxy-pc1.pcap](https://github.com/evaCastro/kathara-labs/blob/main/http/pcap/HTTP-proxy-pc1.pcap)
       - From pc2: [HTTP-proxy-pc2.pcap](https://github.com/evaCastro/kathara-labs/blob/main/http/pcap/HTTP-proxy-pc2.pcap)


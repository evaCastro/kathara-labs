## Configuration files for Kathará HTTPS scenario:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/https/images/https-scenario.png"
     alt="TLS handshake"
     style="float: left; margin-right: 10px;" width=700 />

- pc3 represents certification authority and generates Root CA self-signed certificate, Intermediate CA certificate and pc2 certificate. See [how to generate these certificates inside this kathara network scenario](https://github.com/evaCastro/kathara-labs/blob/main/https/doc/certificates.md)
- pc2 runs an Apache server.
- pc1 requests https://pc2.emp2.com

# Certificates

- pc2.emp2.com has a certificate signed by Intermediate-CA.
- Intermediate-CA has a certificate signed by Root-CA.
- Root-CA is a self-signed certificate

# Installed certificates

- pc1 has installed Root-CA certificate
- pc2 has installed pc2.emp2.com, Intermedidate-CA and Root-CA certificates.

# Start scenario

From repository directory: 

   ```kathara lstart --shared --terminal gnome-terminal```

From pc2 terminal, start apache2 sever (password: ```pc2.emp2.com```):

   ```/etc/init.d/apache2 start```

From r1 terminal, launch tcpdump to save traffic into a file:

```tcpdump -i eth0 -s 0 -w /share/https.cap```

From pc1 terminal: 

   ```wget https://pc2.emp2.com/```

Stop tcpdump and use wireshark to study traffic:

<img src="https://github.com/evaCastro/kathara-labs/blob/main/https/images/certificate-chain.png"
     alt="TLS handshake"
     style="float: left; margin-right: 10px;" width=700 />

Filter traffic using ```tls```, we only want to see TLS traffic (not TCP). pc1 has installed Root CA certificate and receives (see packet 8 in wireshark figure):
- Intermediate CA certificate signed by Root CA
- pc2.emp2.com certificate signed by Intermediate CA.

pc1 can verify certificate chain. 

Besides, pc1 and pc2 use Diffie-Hellman algorithm to establish a shared secret for a symmetric key algorithm to encrypt traffic. 

<img src="https://github.com/evaCastro/kathara-labs/blob/main/https/images/TLS13.png"
     alt="TLS handshake"
     style="float: left; margin-right: 10px;" width=700 />

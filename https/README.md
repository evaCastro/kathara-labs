### Configuration files for Kathará HTTPS scenario:
-  IP addresses, routes, certificates, Apache server.

<img src="https://github.com/evaCastro/kathara-labs/blob/main/https/images/https-scenario.png"
     alt="TLS handshake"
     style="float: left; margin-right: 10px;" />

Certificates

    pc2.emp2.com has a certificate signed by Intermediate-CA.
    Intermediate-CA has a certificate signed by Root-CA.
    Root-CA is a self-signed certificate

Installed certificates

    pc1 has installed Root-CA certificate
    pc2 has installed pc2.emp2.com, Intermedidate-CA and Root-CA certificates.

Start scenario

    From repository directory: kathara start --shared --terminal gnome-terminal
    From pc2 terminal, start apache2: /etc/init.d/apache2 start
    From pc1 terminal: wget https://pc2.emp2.com/


<img src="https://github.com/evaCastro/kathara-labs/blob/main/https/images/certificate-chain.png"
     alt="TLS handshake"
     style="float: left; margin-right: 10px;" />

<img src="https://github.com/evaCastro/kathara-labs/blob/main/https/images/TLS13.png"
     alt="TLS handshake"
     style="float: left; margin-right: 10px;" />

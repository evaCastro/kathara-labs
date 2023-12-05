# kathara-labs
Kathara configuration laboratories

Configuration files for HTTPS scenario: IP addresses, routes, certificates, Apache server.

pc1(eth0) -------r1(eth0)  r1(eth1) ------ r2(eth0) r2(eth1) ------ pc2(eth0)

*IP configuration*
  - pc1(eth0): 11.0.0.10    
  - r1(eth0): 11.0.0.1  
  - r1(eth1): 14.0.0.1     
  - r2(eth0): 14.0.0.2   
  - r2(eth1): 12.0.0.2
  - pc2(eth0): 12.0.0.20

*Certificates*
  - pc2.emp2.com has a certificate signed by Intermediate-CA.
  - Intermediate-CA has a certificate signed by Root-CA.
  - Root-CA is a self-signed certificate

*Installed certificates*
  - pc1 has installed Root-CA certificate
  - pc2 has installed pc2.emp2.com, Intermedidate-CA and Root-CA certificates.

*Start scenario*
   - From repository directory: kathara start --shared --terminal gnome-terminal
   - From pc2 terminal, start apache2: /etc/init.d/apache2 start
   - From pc1 terminal: wget https://pc2.emp2.com

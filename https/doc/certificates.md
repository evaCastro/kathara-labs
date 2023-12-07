## Certificates

From documentation [https://jamielinux.com/docs/openssl-certificate-authority/index.html](https://jamielinux.com/docs/openssl-certificate-authority/index.html).

<img src="https://github.com/evaCastro/kathara-labs/blob/main/https/images/https-scenario.png"
     alt="TLS handshake"
     style="float: left; margin-right: 10px;" width=700 />
     
- pc2.emp2.com has a certificate signed by Intermediate-CA.
- Intermediate-CA has a certificate signed by Root-CA.
- Root-CA is a self-signed certificate

The Root-CA will be configured as policy_strict, as the root CA is only being used to create intermediate CAs ([see file openssl_root.cnf](https://github.com/evaCastro/kathara-labs/blob/main/https/doc/openssl_root.cnf)). The intermediate CA  will be configured as policy_any ([see file openssl_intermediate.cnf](https://github.com/evaCastro/kathara-labs/blob/main/https/doc/openssl_intermediate.cnf)) to sign clients and servers certificates.

### Start scenario

From repository directory: 

   ```kathara lstart --shared --terminal gnome-terminal```

All certificates will be generated in pc3 where the following commands will be executed

### Root-CA self-signed certificate
Prepare directory tree:
```
   # creating some directories for Root-CA
   mkdir -p /root/ca/rootCA
   cd /root/ca/rootCA

   mkdir certs crl newcerts private
   chmod 700 private
   touch index.txt
   echo 1000 > serial
```

Generate private key for Root-CA (enter PEM pass phrase):
```
   openssl genrsa -aes256 -out private/rootCA.key.pem 4096
   chmod 400 private/rootCA.key.pem
```

Generate Root-CA self-signed certificate:
```
   openssl req -config ../../openssl_root.cnf \
        -key private/rootCA.key.pem \
        -new -x509 -days 7300 -sha256 -extensions v3_ca \
        -out certs/rootCA.cert.pem
```

Example values for this certificate:
   - Country Name (2 letter code) [GB]:ES
   - State or Province Name [England]:Madrid
   - Locality Name []:Fuenlabrada
   - Organization Name [Alice Ltd]:Root CA Org.
   - Organizational Unit Name []:Root CA
   - Common Name []:Root-CA
   - Email Address []:admin@rootCA.com

Check the certificate:
```
   openssl x509 -noout -text -in certs/rootCA.cert.pem
```

Relevant information (Issuer, Validity and Subject):
```
**Issuer**: C = ES, ST = Madrid, L = Fuenlabrada, O = Root CA Org., OU = Root CA, **CN = Root-CA**, emailAddress = admin@rootCA.com
Validity
   Not Before: Dec  5 11:22:56 2023 GMT
   Not After : Nov 30 11:22:56 2043 GMT
**Subject**: C = ES, ST = Madrid, L = Fuenlabrada, O = Root CA Org., OU = Root CA, **CN = Root-CA**, emailAddress = admin@rootCA.com
```

Self-signed certificate: Issuer=Subject.


### Intermediate-CA certificate signed by Root-CA
Preparing directory tree:
```
   mkdir -p /root/ca/intermediateCA
   cd /root/ca/intermediateCA

   mkdir certs crl csr newcerts private
   chmod 700 private
   touch index.txt
   echo 1000 > serial
   echo 1000 > /root/ca/intermediateCA/crlnumber
```

Generate private key for Intermediate-CA (enter PEM pass phrase for Intermediate-CA):
```
   openssl genrsa -aes256 -out private/intermediateCA.key.pem 4096
   chmod 400 private/intermediateCA.key.pem
```

Generate certificate signing request for Intermediate-CA (use Intermediate-CA PEM pass phrase). Organization Name value must be "Root CA Org.", also Country and State (policy_strict configuration):
```
   openssl req -config ../../openssl_intermediate.cnf \
        -new -sha256 \
        -key private/intermediateCA.key.pem \
        -out csr/intermediateCA.csr.pem
```

Example values for this certificate:
   - **Country Name (2 letter code) [GB]:ES**
   - **State or Province Name [England]:Madrid**
   - Locality Name []:Fuenlabrada
   - **Organization Name [Alice Ltd]:Root CA Org.**
   - Organizational Unit Name []:Intermediate CA
   - Common Name []:Intermediate-CA
   - Email Address []:admin@intermediateCA.com

Sign Intermediate-CA certificate (take config parameters from ../../openssl_root.cnf). The Root-CA pass phrase is required to sign this certificate:
```
   openssl ca -config ../../openssl_root.cnf -extensions v3_intermediate_ca \
        -days 3650 -notext -md sha256 \
        -in csr/intermediateCA.csr.pem \
        -out certs/intermediateCA.cert.pem
   chmod 444 certs/intermediateCA.cert.pem
   
```

Check the certificate:
```
   openssl x509 -noout -text -in certs/intermediateCA.cert.pem
```

Relevant information (Issuer, Validity and Subject):
```
Issuer: C = ES, ST = Madrid, L = Fuenlabrada, O = Root CA Org., OU = Root CA, **CN = Root-CA**, emailAddress = admin@rootCA.com
Validity
   Not Before: Dec  5 11:27:20 2023 GMT
   Not After : Dec  2 11:27:20 2033 GMT
Subject: C = ES, ST = Madrid, O = Root CA Org., OU = Intermediate CA, **CN = Intermediate-CA**, emailAddress = admin@intermediateCA.com
```

### pc2.emp2.com certificate signed by Root-CA
```
   cd /root/ca/intermediateCA
```

Generate private key for pc2.emp2.com (enter PEM pass phrase for pc2):
```
   openssl genrsa -aes256 -out private/pc2.emp2.com.key.pem 2048
   chmod 400 private/pc2.emp2.com.key.pem
```

Generate certificate signing request for pc2 (use pc2 PEM pass phrase). Take config parameters from ../../openssl_intermediate.cnf. Organization Name value must be "Intermediate CA Org." (from Intermediate-CA certificate):
```
   openssl req -config ../../openssl_intermediate.cnf \
      -key private/pc2.emp2.com.key.pem \
      -new -sha256 -out csr/pc2.emp2.com.csr.pem
```

Example values for this certificate:
   - Country Name (2 letter code) [GB]:ES
   - State or Province Name [England]:Madrid
   - Locality Name []:Fuenlabrada
   - Organization Name [Alice Ltd]:Intermediate CA Org.
   - Organizational Unit Name []:pc2
   - Common Name []:pc2.emp2.com
   - Email Address []:admin@emp2.com

Sign pc2 certificate. The Intermediate-CA pass phrase is required to sign this certificate:
```
   openssl ca -config ../../openssl_intermediate.cnf \
      -extensions server_cert -days 375 -notext -md sha256 \
      -in csr/pc2.emp2.com.csr.pem \
      -out certs/pc2.emp2.com.cert.pem
   chmod 444 certs/pc2.emp2.com.cert.pem
```


Check the certificate:
```
   openssl x509 -noout -text -in certs/pc2.emp2.com.cert.pem
```

Relevant information (Issuer, Validity and Subject):
```
Issuer: C = ES, ST = Madrid, O = My Root CA Org., OU = Intermediate CA, CN = Int CA, emailAddress = admin@intermediate.root
Validity
   Not Before: Dec  4 19:03:44 2023 GMT
   Not After : Dec 13 19:03:44 2024 GMT
Subject: C = ES, ST = Madrid, L = Fuenlabrada, O = NetGUI Org, OU = NetGUI, CN = pc2.emp2.com


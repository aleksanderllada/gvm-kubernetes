#!/bin/bash

mkdir keys
mkdir certs

# Create CA
openssl genrsa -out keys/cakey.pem 4096
openssl req -x509 -new -nodes -key keys/cakey.pem -subj "/C=BR/ST=SP/O=GVM Users/CN=openvas" -sha256 -days 1024 -out certs/cacert.pem

# Create the certificate keys (client and server)
openssl genrsa -out keys/serverkey.pem 2048
openssl genrsa -out keys/clientkey.pem 2048

# Create a certificate signing request
openssl req -new -sha256 -key keys/serverkey.pem -subj "/C=BR/ST=SP/O=GVM Users/CN=openvas" -out servercert.csr
openssl req -new -sha256 -key keys/clientkey.pem -subj "/C=BR/ST=SP/O=GVM Users/CN=openvas" -out clientcert.csr

# Sign the certificate
openssl x509 -req -in servercert.csr -CA certs/cacert.pem -CAkey keys/cakey.pem -CAcreateserial -out certs/servercert.pem -days 1024 -sha256
openssl x509 -req -in clientcert.csr -CA certs/cacert.pem -CAkey keys/cakey.pem -CAcreateserial -out certs/clientcert.pem -days 1024 -sha256

# Clean up
rm *.csr certs/cacert.srl

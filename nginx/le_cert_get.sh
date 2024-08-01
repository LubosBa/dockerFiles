#!/usr/bin/env sh
# This script will generate LE Certs for all the domains specified in LE_CERT.
# Certificates are automatically renewed 15 days before the expiration.
# Created by Lubos Babjak.

# Config
## 15 days
RENEW_PERIOD=1296000
LE_FOLDER='/config/le_certs'
LE_LOGS='/logs/le'

## Meta vars
LE_GETCERT=""
LE_RENEWCERT=""
LE_DAYS=$((RENEW_PERIOD / 86400))


function currentDate() {
    date +"%Y-%m-%d %H:%M:%S"
}

if [ -z "${LE_FQDN}" ]; then
    echo "[$(currentDate)] No LE_FQDN specified, no certs are going to be requested."
    return 1
fi

function checkExpiration() {
    for FQDN in ${LE_FQDN}; do
        cert="${LE_FOLDER}/certs/${FQDN}.crt"
        if [ ! -f "${cert}" ]; then
            LE_GETCERT="${LE_GETCERT} ${FQDN}"
            echo "[$(currentDate)] ${FQDN} doesn't have certificate present! Will generate new one."
        else
            # Check expiration date of existing certificate
            openssl x509 -checkend ${RENEW_PERIOD} -noout -in ${cert} >/dev/null
            if [ $? -ne 0 ]; then
                LE_RENEWCERT="${LE_RENEWCERT} ${FQDN}"
                echo "[$(currentDate)] ${FQDN} will expire  within next ${LE_DAYS} days. Adding to renewal list."
            else
                echo "[$(currentDate)] ${FQDN} doesn't expire within next ${LE_DAYS} days."
            fi
        fi
    done
}

function generateCert() {
    for FQDN in ${LE_RENEWCERT}; do
        config="${LE_FOLDER}/conf/${FQDN}.conf"
        csr="${LE_FOLDER}/csr/${FQDN}.csr"
        key="${LE_FOLDER}/pkey/${FQDN}.pkey"
        if [ ! -f "${config}" ] || [ ! -f "${csr}" ] || [ ! -f "${key}" ]; then
            echo "[$(currentDate)] ${FQDN} missing ${config} or ${csr} or ${key}. Check, if it's present."
            return 1
        else
            # Request cert
            echo "[$(currentDate)] ${FQDN} requesting a new certificate from Let's Encrypt, wait a minute!"
            certbot certonly -c ${LE_FOLDER}/conf/${FQDN}.conf --logs-dir "${LE_LOGS}" --quiet --dry-run
            if [ $? -ne 0 ]; then
                echo "[$(currentDate)] ${FQDN} failed to request the certificate."
                return 1
            else
                echo "[$(currentDate)] ${FQDN} successfully requested the certificate."
            fi
        fi
    done
}

function generateOpenSSLConfig() {
    for FQDN in ${LE_GETCERT}; do
        echo "[$(currentDate)] ${FQDN} Generating OpenSSL configuration."
        cat <<-EOL > "${LE_FOLDER}/conf/${FQDN}.openssl.conf"
[req]
default_bits = 4096
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=SK
ST=Zapad
L=Bratislava
O=Lubos
OU=Devops
emailAddress=admin@${FQDN}
CN = ${FQDN}
        
[ req_ext ]
subjectAltName = @alt_names
        
[ alt_names ]
DNS.1 = *.${FQDN}
EOL
        if [ -f "${LE_FOLDER}/conf/${FQDN}.openssl.conf" ]; then
            echo "[$(currentDate)] ${FQDN} OpenSSL config successfully generated"
        else
            echo "[$(currentDate)] ${FQDN} OpenSSL config generation failed!"
            return 1
        fi

        # Generate pkey
        echo "[$(currentDate)] ${FQDN} Generating private key to ${LE_FOLDER}/pkey/${FQDN}.pkey"
        openssl genpkey -algorithm RSA -out "${LE_FOLDER}/pkey/${FQDN}.pkey" -pkeyopt rsa_keygen_bits:4096 > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "[$(currentDate)] ${FQDN} failed to generate pkey: ${LE_FOLDER}/pkey/${FQDN}.pkey"
            return 1
        else
            echo "[$(currentDate)] ${FQDN} successfully generated pkey: ${LE_FOLDER}/pkey/${FQDN}.pkey"
        fi

        # Generate csr
        echo "[$(currentDate)] ${FQDN} Generating csr to ${LE_FOLDER}/csr/${FQDN}.csr"
        openssl req -new -config "${LE_FOLDER}/conf/${FQDN}.openssl.conf" -out "${LE_FOLDER}/csr/${FQDN}.csr" -key "${LE_FOLDER}/pkey/${FQDN}.pkey" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "[$(currentDate)] ${FQDN} failed to generate csr: ${LE_FOLDER}/csr/${FQDN}.csr"
            return 1
        else
            echo "[$(currentDate)] ${FQDN} successfully generated csr: ${LE_FOLDER}/csr/${FQDN}.csr"
        fi

    done
}

function generateCertBotConfig() {
    for FQDN in ${LE_GETCERT}; do
        echo "[$(currentDate)] ${FQDN} Generating certbot configuration."
        cat <<-EOL > "${LE_FOLDER}/conf/${FQDN}.conf"
# General configuration
rsa-key-size = 4096
authenticator = dns-cloudflare
agree-tos
server = https://acme-v02.api.letsencrypt.org/directory
renew-by-default
email = admin@${FQDN}
dns-cloudflare-credentials = ${LE_FOLDER}/conf/cf.ini
dns-cloudflare-propagation-seconds = 60

# Path configuration
csr = ${LE_FOLDER}/csr/${FQDN}.csr
cert-path = ${LE_FOLDER}/certs/${FQDN}.crt
key-path = ${LE_FOLDER}/pkey/${FQDN}.pkey
fullchain-path = ${LE_FOLDER}/fullchain/${FQDN}.crt

# Domain configuration
domains = *.${FQDN}
EOL
        if [ -f "${LE_FOLDER}/conf/${FQDN}.conf" ]; then
            echo "[$(currentDate)] ${FQDN} certbot config successfully generated"
            echo "[$(currentDate)] ${FQDN} Adding domain to the list for cert generation."
            LE_RENEWCERT="${LE_RENEWCERT} ${FQDN}"
        else
            echo "[$(currentDate)] ${FQDN} certbot config generation failed: ${LE_FOLDER}/conf/${FQDN}.conf !"
            return 1
        fi
    done

    echo "[$(currentDate)] certbot generating CF config: ${LE_FOLDER}/conf/cf.ini"
    cat <<-EOL > "${LE_FOLDER}/conf/cf.ini"
dns_cloudflare_email = ${CF_EMAIL}
dns_cloudflare_api_key = ${CF_API_KEY}
EOL

    if [ -f "${LE_FOLDER}/conf/cf.ini" ]; then
        echo "[$(currentDate)] certbot CF config successfully generated"
    else
        echo "[$(currentDate)] certbot CF config successfully generated failed: ${LE_FOLDER}/conf/cf.ini !"
        return 1
    fi
}



checkExpiration
generateOpenSSLConfig
generateCertBotConfig
generateCert

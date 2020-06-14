#!/usr/bin/env bash
# This is an entrypoint of Docker le_auto_certs container, it will setup some
# sane configuration for the container and copy over the configuration files.
# Created by Lubos Babjak.

# Get IP address of container.
IP="$(ip addr show | grep inet | grep -v '127.0.0.1' | head -1 | awk '{ print $2}' |  awk -F'/' '{print $1}')"
# Get hostname
HOSTNAME="$(hostname -s)"

# Check, if certs folder is empty:
if [[ -z "$(ls -A /certs/)" ]]; then
    mkdir -p /certs/{conf,csr,fullchain,certs}
fi

# export env variables.
export IP HOSTNAME

function interactive {
    echo "Starting interactive mode."
    echo "Run docker exec -it <container-name> bash in different console"
    while true
    do
        sleep 5
    done
}

function truststoreGen {
    # Check, if keystore password has been specified.
    if [[ -z "${2}" ]]; then
        echo "Please specify keystore password!"
        exit 1
    fi

    # Check, if truststore folder exists.
    if [[ ! -d "/certs/truststores" ]]; then
        mkdir -p "/certs/truststores/backup"
    fi

    # Check, if we already have an existing crt + pkey combination.
    if [[ -f "/certs/truststores/${1}.p12" ]]; then
        mv "/certs/truststores/${1}.p12" "/certs/truststores/backup/${1}_$(date +'%Y-%m-%d-%H-%M-%S').p12"
    fi

    # Check, if we already have a keystore.
    if [[ -f "/certs/truststores/${1}_keystore.jks" ]]; then
        mv "/certs/truststores/${1}_keystore.jks" "/certs/truststores/backup/${1}_keystore_$(date +'%Y-%m-%d-%H-%M-%S').jks"
    fi

    # Create crt + pkey combi pkcs12 key.
    openssl pkcs12 -export -inkey "/certs/csr/${1}.pkey" -in "/certs/certs/${1}.crt" -name "${1}" -out "/certs/truststores/${1}.p12" -password pass:${2}

    # Generate java keystore from the pkcs12 cert/key file.
    keytool -importkeystore -srckeystore "/certs/truststores/${1}.p12" -srcstoretype pkcs12 -destkeystore "/certs/truststores/${1}_keystore.jks" -storepass ${2} -srcstorepass ${2}
}

function certGen {
    # Check, if FQDN has been specified.
    if [[ -z "${1}" ]]; then
        echo "No FQDN specified, please specify one!"
        exit 1
    fi

    # Check, if LE configuration exists for provided fqdn.
    if [[ ! -f "/certs/conf/${1}.conf" ]]; then
        echo "Couldn't find LE confiugration in /certs/conf/${1}.conf"
        exit 1
    fi

    # Check, if csr and pkey exists.
    if [[ ! -f "/certs/csr/${1}.csr" || ! -f "/certs/csr/${1}.pkey" ]]; then
        echo "Make sure that CSR and PKEY can be found in /certs/csr/${1}.csr /certs/csr/${1}.pkey"
        exit 1
    fi

    # Check, if we already have an existing cert and back it up.
    if [[ -f "/certs/certs/${1}.crt" ]]; then
        mkdir -p "/certs/certs/backup/"
        mkdir -p "/certs/fullchain/backup/"
        mv "/certs/certs/${1}.crt" "/certs/certs/backup/${1}_$(date +'%Y-%m-%d-%H-%M-%S').crt"
        mv "/certs/fullchain/${1}.crt" "/certs/fullchain/backup/${1}_$(date +'%Y-%m-%d-%H-%M-%S').crt"
    fi

    # Request new LE certificate.
    certbot certonly -c /certs/conf/${1}.conf

    # Check, if we should generate a truststore + keystore
    if [[ "${2}" == "--keystore" ]]; then
        truststoreGen ${1} ${3}
    fi
}

case "${1}" in
    "--interactive")
        interactive
        ;;
    "--cert-get")
        certGen ${2} ${3} ${4}
        ;;
    *)
        echo "No armugment specified, use --interactive or --cert-get <domain-name> [--keystore] [keystore-password]"
        exit 1
        ;;
esac

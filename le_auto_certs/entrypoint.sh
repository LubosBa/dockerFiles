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

    certbot certonly -c /certs/conf/${1}.conf
}

case "${1}" in
    "--interactive")
        interactive
        ;;
    "--cert-get")
        certGen ${2}
        ;;
    *)
        echo "No armugment specified, use --interactive or --cert-get <domain-name>"
        exit 1
        ;;
esac

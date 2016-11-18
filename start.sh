#!/bin/sh
sudo modprobe af_key

mkdir -p etc/ipsec.d
mkdir -p etc/ppp
touch etc/ipsec.d/passwd
touch etc/ppp/chap-secrets
touch etc/ipsec.secrets

docker run \
    --name ipsec-vpn-server \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -v /lib/modules:/lib/modules:ro \
    -v "$PWD/etc/ppp/chap-secrets:/etc/ppp/chap-secrets" \
    -v "$PWD/etc/ipsec.d/passwd:/etc/ipsec.d/passwd" \
    -v "$PWD/etc/ipsec.secrets:/etc/ipsec.secrets" \
    -v /lib/modules:/lib/modules:ro \
    -d --privileged \
    --restart=always \
    mobilejazz/docker-ipsec-vpn-server
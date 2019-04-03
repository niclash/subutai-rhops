#!/bin/bash
#
#

function help {
    echo "./hetzner-boot-ex41.sh HOSTNAME\n\nExample:\n\n\t./hetzner-boot-ex41.sh n2"
}

if [ -z $1 ] ; then
    help
    exit
fi

HOST=$1
FULLHOST=$1.sensetif.net
IP=$(dig +search +short $FULLHOST | grep ^[0-9])
ssh-keygen -q -R $HOST
ssh-keygen -q -R $FULLHOST
ssh-keygen -q -R $IP
ssh-keyscan -H $FULLHOST >> ~/.ssh/known_hosts



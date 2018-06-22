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
FULLHOST=$1.bali.io
IP=$(dig +search +short $HOST | grep ^[0-9])
ssh-keygen -q -R $HOST
ssh-keygen -q -R $FULLHOST
ssh-keygen -q -R $IP
ssh-keyscan -H $FULLHOST >> ~/.ssh/known_hosts

ssh root@$FULLHOST "/root/.oldroot/nfs/install/installimage \
              -a  \
              -b grub \
              -r no \
              -l 0 \
              -d sda \
              -n $HOST \
              -p /boot:ext3:1G,lvm:vg0:all \
              -v vg0:root:/:ext4:100G,vg0:swap:swap:swap:32G,vg0:home:/home:xfs:100G,vg0:var:/var:xfs:200G,vg0:ipfs:/ipfs:xfs:2000G \
              -s en \
              -i /root/images/Debian-94-stretch-64-minimal.tar.gz \
              -K https://raw.githubusercontent.com/eosgermany/public_meta/master/authorized_keys \
              && rm /etc/ssh/ssh_host_rsa_key \
              && rm /etc/ssh/ssh_host_dsa_key \
              && rm /etc/ssh/ssh_host_ecdsa_key \
              && ssh-keygen -q -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
              && ssh-keygen -q -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
              && ssh-keygen -q -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521 \
              && /sbin/reboot
              "

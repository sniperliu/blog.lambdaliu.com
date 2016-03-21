#!/bin/bash

DIGITALOCEAN_ACCESS_TOKE=`cat ~/.ssh/digital_ocean_token`

docker-machine create --driver digitalocean \
	       --digitalocean-access-token=$DIGITALOCEAN_ACCESS_TOKE \
	       --digitalocean-region=sgp1 \
	       --digitalocean-image=ubuntu-15-10-x64 \
	       --digitalocean-size=512mb \
	       ansible-sandbox

# eval $(docker-machine env ansibleprovision)

# docker-compose build .

# docker build -t ansible-provision .

# docker run \
    # --rm \
    # --net host \
    # -v /root/.ssh:/hostssh \
    # nathanleclaire/ansibleprovision

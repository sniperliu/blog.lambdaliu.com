#!/bin/bash

DIGITALOCEAN_ACCESS_TOKEN=`cat ~/.ssh/digital_ocean_token`

docker-machine create --driver digitalocean \
	       --digitalocean-access-token=$DIGITALOCEAN_ACCESS_TOKEN \
	       --digitalocean-image=ubuntu-15-10-x64 \
	       --digitalocean-region=sgp1 \
	       --digitalocean-size=512mb \
	       ansible-sandbox

eval $(docker-machine env ansible-sandbox)


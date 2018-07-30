#!/bin/sh

echo "Downloading BGBillingServer image"
docker pull bgbilling/server:7.2
docker pull bgbilling/scheduler:7.2
echo "Downloading ActiveMQ image"
docker pull bgbilling/activemq
echo "Downloading MySQL image"
docker pull mysql:5.7

STACK_DIR=$(dirname "$0")
if [ -z "$STACK_DIR" ]; then
  STACK_DIR="."
fi

echo "Deploing bgbilling-docker"
docker stack deploy -c ${STACK_DIR}/docker-stack.yml bgbilling

# show logs
timeout 300 docker service logs bgbilling_db --follow & timeout 300 docker service logs bgbilling_server --follow || docker ps

# remove
#docker stack rm bgbilling
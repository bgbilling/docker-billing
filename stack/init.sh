#!/bin/sh

echo "Downloading BGBillingServer image"
docker pull bgbilling/server:7.1
docker pull bgbilling/scheduler:7.1
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

${STACK_DIR}/start.sh

docker ps
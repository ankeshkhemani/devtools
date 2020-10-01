#!/usr/bin/env bash

echo "Stop"
docker stop devtools > /dev/null || true
docker rm devtools > /dev/null || true

echo "Run"
docker run \
    --name devtools \
    --detach \
    --restart unless-stopped \
    --env DEPLOYMENT="develop" \
    --env LOG_LEVEL="DEBUG" \
    --network host \
    --env MONGO_LOG_URI="mongodb://devops:devops@localhost:27017" \
    devtools

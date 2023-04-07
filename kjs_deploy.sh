#!/bin/bash -e

docker login registry.cn-shanghai.aliyuncs.com

sudo mkdir -p /docker/logs/v-gateway

sudo mkdir -p /docker/logs/v-auth

sudo mkdir -p /docker/logs/v-mem

sudo mkdir -p /docker/logs/v-pay

sudo mkdir -p /docker/logs/gdns

sudo mkdir -p /docker/nginx/www/static/file

sudo mkdir -p /docker/logs/v-pub

echo "---created gnds-----"
docker pull registry.cn-shanghai.aliyuncs.com/v_swarm/gdns-proxy:1.0.3-SNAPSHOT

docker service create -p 2101:2101 --network=v_overlay \
--log-driver="none" \
--mount type=bind,source=/docker/logs/gdns,target=/logs \
--name="gdns" --host nacos:10.10.1.2 \
-e "spring.profiles.active=prod" \
--constraint 'node.labels.tagName == node1' \
--replicas 1 \
registry.cn-shanghai.aliyuncs.com/v_swarm/gdns-proxy:1.0.3-SNAPSHOT

echo "---created pay-----"
docker pull registry.cn-shanghai.aliyuncs.com/v_swarm/v-pay:1.0.3-SNAPSHOT

docker service create --network=v_overlay \
--log-driver="none" \
--constraint 'node.labels.tagName == node1' \
--mount type=bind,source=/docker/logs/v-pay,target=/logs \
--name="v-pay" --host nacos:10.10.1.2 \
-e "spring.profiles.active=prod" \
registry.cn-shanghai.aliyuncs.com/v_swarm/v-pay:1.0.3-SNAPSHOT

echo "---created gateway-----"
docker pull registry.cn-shanghai.aliyuncs.com/v_swarm/v-gateway:1.0.6-SNAPSHOT
docker service create -p 2100:2100 --network=v_overlay \
--log-driver="none" \
--constraint 'node.labels.tagName == node1' \
--mount type=bind,source=/docker/logs/v-gateway,target=/logs \
--name="v-gateway" --host nacos:10.10.1.2 \
-e "spring.profiles.active=prod" \
registry.cn-shanghai.aliyuncs.com/v_swarm/v-gateway:1.0.6-SNAPSHOT

echo "---created auth-----"
docker pull registry.cn-shanghai.aliyuncs.com/v_swarm/v-auth:1.1.5-SNAPSHOT

docker service create --network=v_overlay \
--log-driver="none" \
--constraint 'node.labels.tagName == node1' \
--mount type=bind,source=/docker/logs/v-auth,target=/logs \
--name="v-auth" --host nacos:10.10.1.2 \
-e "spring.profiles.active=prod" \
registry.cn-shanghai.aliyuncs.com/v_swarm/v-auth:1.1.5-SNAPSHOT

echo "---created mem-----"
docker pull registry.cn-shanghai.aliyuncs.com/v_swarm/v-mem:1.2.4-SNAPSHOT

docker service create --network=v_overlay \
--log-driver="none" \
--constraint 'node.labels.tagName == node1' \
--mount type=bind,source=/docker/logs/v-mem,target=/logs \
--name="v-mem" --host nacos:10.10.1.2 \
-e "spring.profiles.active=prod" \
registry.cn-shanghai.aliyuncs.com/v_swarm/v-mem:1.2.4-SNAPSHOT

echo "---created pub-----"
docker pull registry.cn-shanghai.aliyuncs.com/v_swarm/v-pub:1.0.3-SNAPSHOT

docker service create --network=v_overlay --log-driver="none" --constraint 'node.labels.tagName == node1' --mount type=bind,source=/docker/logs/v-pub,target=/logs --mount type=bind,source=/docker/nginx/www/static/file,target=/file --name="v-pub" --host nacos:10.10.1.2 -e "spring.profiles.active=prod" registry.cn-shanghai.aliyuncs.com/v_swarm/v-pub:1.0.3-SNAPSHOT

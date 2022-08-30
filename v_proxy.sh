#!/bin/bash -e

if [ $# == 0 ] ; then
   echo "please input param, tcpport1 httpport2 version serviceName, example ./v2_proxy.sh 20207 20208 1.1.0 kjs-proxy appId ssl"
   exit 0
fi

sudo rm -rf /docker/config/$4

sudo rm -rf /docker/cert/$4

sudo rm -rf /docker/logs/$4

sudo mkdir -p /docker/config/$4

sudo mkdir -p /docker/cert/$4

echo "---created /docker/v2ray/"

sudo mkdir -p /docker/logs/$4

echo "---created /docker/v2ray/logs"


set +e

if [ ! -f "/docker/cert/$4/fullchain.pem" ];then
	sudo wget -P /docker/cert/$4  http://13.70.5.151/cert/gjk1jng.xyz/fullchain.pem
fi

if [ ! -f "/docker/cert/$4/privkey.pem" ];then
	sudo wget -P /docker/cert/$4  http://13.70.5.151/cert/gjk1jng.xyz/privkey.pem
fi

set -e


echo "check Docker......"
docker -v
if [ $? -eq  0 ]; then
    echo "检查到Docker已安装!"
else
    echo "安装docker环境..."
    yum install -y yum-utils device-mapper-persistent-data
    yum-config-manager --add-repo  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    yum install docker-ce-18.06.1*
    echo "安装docker环境...安装完成!"
fi

echo "---start pull v2ray/official----"
docker login registry.cn-shanghai.aliyuncs.com
docker pull registry.cn-shanghai.aliyuncs.com/v_swarm/v-proxy:$3-SNAPSHOT
echo "---end ------"

echo "---start run docker----"
set +e
docker stop $4
docker rm $4
set -e
docker run -m 1024M --dns=114.114.114.114 --net host -d -p $1:$1 -p $2:$2 --log-driver="none" --restart=always -v /docker/config/$4:/config -v /docker/logs/$4:/logs -v /docker/cert/$4:/cert -v /docker/data/$4:/data --name=$4 -e "logging.level.com.vpn.serv=info" -e "JAVA_OPTS=-Xms512m -Xmx512m" -e "spring.profiles.active=prod" -e "server.uid=$5" -e "server.port=$2" -e "vpn.proxy.localPort=$1" --init registry.cn-shanghai.aliyuncs.com/v_swarm/v-proxy:$3-SNAPSHOT
echo "---start sccuess-------"

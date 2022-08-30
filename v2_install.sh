#!/bin/bash

if [ $# == 0 ] ; then
   echo "please input params, hk(香港)，jp(日本)，ag(美国)，am（澳门）"
   exit 0
fi

sudo rm -rf /docker/v2ray

sudo mkdir -p /docker/v2ray

echo "---created /docker/v2ray/"

sudo mkdir -p /docker/v2ray/logs

echo "---created /docker/v2ray/logs"

echo "---start pull v2ray/official----"
docker pull v2ray/official
echo "---end ------"

case "$1" in 

    hk) 
	echo "---installing 香港----"
	wget -P /docker/v2ray  http://40.73.117.189/v2/config_hk.json
	mv /docker/v2ray/config_hk.json /docker/v2ray/config.json 
	;;
    jp)
	echo "---installing 日本----"
	wget -P /docker/v2ray  http://40.73.117.189/v2/config_jp.json
	mv /docker/v2ray/config_jp.json /docker/v2ray/config.json
	;;
    ag)
	echo "---installing 美国----"
	wget -P /docker/v2ray  http://40.73.117.189/v2/config_ag.json
	mv /docker/v2ray/config_ag.json /docker/v2ray/config.json	
	;;
    am)
        echo "---installing 澳门----"
	wget -P /docker/v2ray  http://40.73.117.189/v2/config_am.json
    	mv /docker/v2ray/config_am.json /docker/v2ray/config.json
	;;
    *)
	echo "-------------other"
	;;
esac

if [ ! -d "/docker/v2ray/config.json" ];then
   	sudo chmod -R 776 /docker/v2ray/config.json
   else
	exit 0
fi

echo "---start run docker----"
docker stop v2ray
docker rm v2ray
docker run -d --name v2ray --restart=always -v /docker/v2ray:/etc/v2ray -v /docker/v2ray/logs:/var/log/v2ray -p 10175:10175 -p 10075:10075 --restart=always v2ray/official v2ray -config=/etc/v2ray/config.json
echo "---start sccuess-------"

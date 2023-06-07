#!/bin/bash -e

if [ $# == 0 ] ; then
   echo "please input params,
	id 印度
	ch 中国
	ag 美国
	am 澳门
	sk 韩国
	jp 日本
	sg 新加坡
	tw 台湾
	agt 阿根廷
	hk 香港
	ci 智利
	ice 冰岛
	rs 俄罗斯
	td 泰国
	as 澳大利亚
	isa 马来西亚
	bt 英国
	bz 巴西
	cnd 加拿大
	fn 法国
	gm 德国
	hn 荷兰

	yn 越南
	ydl 意大利
	lr 印度尼西亚
	plp 菲律宾
	ngr 尼日利亚

	sz 瑞士
	nzl 新西兰
	atr 奥地利
	sa 南非
	nw 挪威
	ukl 乌克兰
	sd 瑞典
	pty 葡萄牙
	tk 土耳其
	fil 芬兰
    {0/1} {20207} {20208} {1.2.7} kjs-{} {redirectPort}"
   exit 0
fi

#sudo rm -rf /docker/tv2

sudo mkdir -p /docker/tv2

echo "---created /docker/v2ray/"

sudo mkdir -p /docker/tv2/logs

echo "---created /docker/v2ray/logs"

echo "check Docker......"
sudo docker -v
if [ $? -eq  0 ]; then
    echo "检查到Docker已安装!"
else
    echo "安装docker环境..."
    sudo yum install -y yum-utils device-mapper-persistent-data
    sudo yum-config-manager --add-repo  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    sudo yum install docker-ce-18.06.1*
    echo "安装docker环境...安装完成!"
fi


echo "---start pull v2ray/official----"
#sudo docker login registry.cn-shanghai.aliyuncs.com
sudo docker pull moyandoc/kv2:4.31.0
echo "---end ------"

case "$1" in 

    hk) 
	echo "---installing 香港----"
	;;
    jp)
	echo "---installing 日本----"
	;;
    ag)
	echo "---installing 美国----"
	;;
    am)
        echo "---installing 澳门----"
	;;
    tw)
        echo "---installing 台湾----"
	;;
    sk)
        echo "---installing 韩国----"
	;;
    *)
	echo "-------------other"
	;;
esac

sudo rm -rf /docker/tv2

sudo mkdir -p /docker/tv2/

sudo wget -O /docker/tv2/config.json https://raw.githubusercontent.com/moyangit/k_shell/master/config_excn.json 

sudo sed -i "s/country_code/$1/g" /docker/tv2/config.json
sudo sed -i "s/local_flow_port/$7/g" /docker/tv2/config.json

#sudo mv /docker/tv2/config_$1.json /docker/tv2/config.json

if [ ! -d "/docker/tv2/config.json" ];then
   	sudo chmod -R 776 /docker/tv2/config.json
   else
	exit 0
fi

echo "---start run v2----"


exist=`docker inspect --format '{{.State.Running}}' tv2`


if [ "${exist}" != "true" ]; 
then
docker run -d --net host --name tv2 \
--restart=always \
-v /docker/tv2:/etc/v2ray \
-v /docker/tv2/logs:/var/log/v2ray \
--restart=always moyandoc/kv2:4.31.0

else
	
	set +e
	docker stop tv2 
	docker rm tv2
	set -e
	docker run -d --net host --name tv2 \
	--restart=always \
	-v /docker/tv2:/etc/v2ray \
	-v /docker/tv2/logs:/var/log/v2ray \
	--restart=always moyandoc/kv2:4.31.0
	
echo "--v2 run success"
fi
echo "--v2 run exist"

set -e
#如果第二个参数为1，则直连，这时安装一个代理插件
if [ $2 -eq 1 ];then
echo "---start pull proxy----"
sudo docker pull moyandoc/tpr:$5-SNAPSHOT
echo "---end ------"

set +e
docker stop $6
docker rm $6
set -e

#contain_name=$6
#arr_name=(${contain_name//-/ }) 
docker run -m 512M --net host -d -p $3:$3 -p $4:$4 --restart=always --log-driver="none" -v /docker/config/$6:/config -v /docker/logs/$6:/logs -v /docker/data/$6:/data --name=$6 -e "logging.level.com.vpn.serv=info" -e "JAVA_OPTS=-Xms128m -Xmx512m" -e "spring.profiles.active=prod" -e "server.port=$4" -e "vpn.proxy.localPort=$3" -e "proxy.direct.name=$1" -e "proxy.direct.localPort=$7" --init moyandoc/tpr:$5-SNAPSHOT
echo "---start sccuess-------"
fi

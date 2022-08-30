#!/bin/bash -e

if [ $# == 0 ] ; then
   echo "please input domain,example xx in 'xx.domain.com' 1:domainName, 2:force delete (1)"
   exit 0
fi

if [ $2 == 11 ]; then
  echo "deleting down file"
  sudo rm -rf /docker/nginx/www/down/kjs/
  sudo rm -rf /docker/nginx/
else
  echo "ingore down file"
fi

if [ $2 == 12 ]; then
  echo "deleting down file"
  sudo rm -rf /docker/nginx/www/down/hb/
  sudo rm -rf /docker/nginx/
else
  echo "ingore down file"
fi

set +e
sudo apt install -y unzip
sudo yum install -y unzip
set -e
sudo mkdir -p /docker/nginx/www/down/hb/
sudo mkdir -p /docker/nginx/www/down/kjs/
sudo mkdir -p /docker/nginx/confs/cert/kjsddns.com/
sudo mkdir -p /docker/nginx/logs/

echo "create Dir completed"

echo "check Docker installed......"
sudo docker -v
if [ $? -eq  0 ]; then
    echo "检查到Docker已安装!"
else
    echo "安装docker环境..."
	set +e
    wget -qO- https://get.docker.com/ | sudo sh
	set -e
    echo "安装docker环境...安装完成!"
fi

echo "---start pull nginx1.14.2----"
sudo docker pull nginx:1.14.2
echo "---end ------"


echo "---domain $1----"

#create file
sudo touch /docker/nginx/confs/down.conf

sudo chmod -R 777 /docker/*

#write nginx config into file
sudo cat > /docker/nginx/confs/down.conf << EOF

server {
    listen       80;
    server_name  $1.kjsddns.com;

    rewrite ^(.*)$  https://$host$1 permanent;
}


server {	
	listen       443;
    server_name  $1.kjsddns.com;
    ssl on;
    ssl_certificate /etc/nginx/conf.d/cert/kjsddns.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/conf.d/cert/kjsddns.com/privkey.pem;

    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
	
	location / {
        root   /etc/nginx/html/down/;
    }
}

EOF

set +e
#auto config dns host
exist=`docker inspect --format '{{.State.Running}}' ddns`
echo "ddns contain $exist"
if [ "${exist}" != "true" ]; 
then
docker run -d --name=ddns -e API_KEY=3_kB661u7VPN4oEHlKoMeD6l2SIPtDpKsx6IQAoJ -e ZONE=kjsddns.com -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
echo "ddns run success"
else
	set +e
	docker stop ddns
	docker rm ddns
	set -e
	docker run -d --name=ddns -e API_KEY=3_kB661u7VPN4oEHlKoMeD6l2SIPtDpKsx6IQAoJ -e ZONE=kjsddns.com -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
	echo "ddns run success"
fi
set -e


#down files to local
#hb file
set +e
if [ ! -f "/docker/nginx/www/down/hb/hb_ad.apk" ];then
   	sudo wget -P /docker/nginx/www/down/hb/  https://dw.sa656xz.com/hb/hb_ad.apk
fi

if [ ! -f "/docker/nginx/www/down/hb/hb_pc.exe" ];then
	sudo wget -P /docker/nginx/www/down/hb/  https://dw.sa656xz.com/hb/hb_pc_build.zip
	sudo unzip /docker/nginx/www/down/hb/hb_pc_build.zip
	sudo wget -P /docker/nginx/www/down/hb/  https://dw.sa656xz.com/hb/hb_pc.exe
fi

if [ ! -f "/docker/nginx/www/down/hb/hb_mac.dmg" ];then
	sudo wget -P /docker/nginx/www/down/hb/  https://dw.sa656xz.com/hb/hb_mac.dmg
fi

#kjs file
if [ ! -f "/docker/nginx/www/down/kjs/kjs_ad.apk" ];then
	sudo wget -P /docker/nginx/www/down/kjs/  https://dw.sa656xz.com/kjs/kjs_ad.apk
fi
	
if [ ! -f "/docker/nginx/www/down/kjs/kjs_pc.exe" ];then
	sudo wget -P /docker/nginx/www/down/kjs/  https://dw.sa656xz.com/kjs/kjs_pc_build.zip
	sudo unzip /docker/nginx/www/down/kjs/kjs_pc_build.zip
	sudo wget -P /docker/nginx/www/down/kjs/  https://dw.sa656xz.com/kjs/kjs_pc.exe
fi

if [ ! -f "/docker/nginx/www/down/kjs/kjs_mac.dmg" ];then
	sudo wget -P /docker/nginx/www/down/kjs/  https://dw.sa656xz.com/kjs/kjs_mac.dmg
fi

if [ ! -f "/docker/nginx/confs/cert/kjsddns.com/fullchain.pem" ];then
	sudo wget -P /docker/nginx/confs/cert/kjsddns.com/  https://dw.sa656xz.com/cert/kjsddns.com/fullchain.pem
fi

if [ ! -f "/docker/nginx/confs/cert/kjsddns.com/privkey.pem" ];then
	sudo wget -P /docker/nginx/confs/cert/kjsddns.com/  https://dw.sa656xz.com/cert/kjsddns.com/privkey.pem
fi

set -e

sudo chmod -R 777 /docker/*

echo ">>start run nginx<<"
set +e
docker stop downFile
docker rm downFile
set -e
set +e
exist=`docker inspect --format '{{.State.Running}}' downFile`
if [ "${exist}" != "true" ]; then
docker run -d -p 80:80 -p 443:443 --restart=always  -v /docker/nginx/confs/:/etc/nginx/conf.d/ -v /docker/nginx/logs/:/var/log/nginx/ -v /docker/nginx/www/:/etc/nginx/html/ --name downFile nginx:1.14.2
echo "nginx run success"
fi
set -e

kjsData="[{\"type\":\"1\", \"name\":\"$1\", \"path\":\"https://$1.kjsddns.com/kjs/kjs_pc.exe\",\"downType\":\"1\"},{\"type\":\"2\", \"name\":\"$1\", \"path\":\"https://$1.kjsddns.com/kjs/kjs_ad.apk\",\"downType\":\"1\"},{\"type\":\"4\", \"name\":\"$1\", \"path\":\"https://$1.kjsddns.com/kjs/kjs_mac.dmg\",\"downType\":\"1\"}]"

echo "kjs:$kjsData"

curl -X POST -H "Content-Type:application/json" -d "$kjsData" "https://cmem.api.kuaijiasuhouduan.com/auth_api/appDownloa/adds"


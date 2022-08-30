#!/bin/bash -e

if [ $# == 0 ] ; then
   echo "please input domain,path 1:domainName, 2:hk"
   exit 0
fi


sudo mkdir -p /docker/nginx/confs/cert/gjk1jng.xyz/
sudo mkdir -p /docker/nginx/logs/


echo "---start pull nginx1.14.2----"
sudo docker pull nginx:1.14.2
echo "---end ------"


echo "---domain $1----"
echo "---domain $1----"

#create file
sudo touch /docker/nginx/confs/v2ray.conf

sudo chmod -R 777 /docker/*

#write nginx config into file
sudo cat > /docker/nginx/confs/v2ray.conf << EOF


server {	
	listen       10443;
    server_name  $1.gjk1jng.xyz;
    ssl on;
    ssl_certificate /etc/nginx/conf.d/cert/gjk1jng.xyz/fullchain.pem;
    ssl_certificate_key /etc/nginx/conf.d/cert/gjk1jng.xyz/privkey.pem;

    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:AES128-SHA:AES256-SHA:DES-CBC3-SHA;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
	
	location /general/$2 {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10175;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}

EOF

set +e
#auto config dns host
exist=`docker inspect --format '{{.State.Running}}' ddns`
echo "ddns contain $exist"
if [ "${exist}" != "true" ]; 
then
docker run -d --name=ddns -e API_KEY=3_kB661u7VPN4oEHlKoMeD6l2SIPtDpKsx6IQAoJ -e ZONE=gjk1jng.xyz -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
echo "ddns run success"
else
	set +e
	docker stop ddns
	docker rm ddns
	set -e
	docker run -d --name=ddns -e API_KEY=3_kB661u7VPN4oEHlKoMeD6l2SIPtDpKsx6IQAoJ -e ZONE=gjk1jng.xyz -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
	echo "ddns run success"
fi
set -e


#down files to local
#hb file
set +e

if [ ! -f "/docker/nginx/confs/cert/gjk1jng.xyz/fullchain.pem" ];then
	sudo wget -P /docker/nginx/confs/cert/gjk1jng.xyz/  http://13.70.5.151/cert/gjk1jng.xyz/fullchain.pem
fi

if [ ! -f "/docker/nginx/confs/cert/gjk1jng.xyz/privkey.pem" ];then
	sudo wget -P /docker/nginx/confs/cert/gjk1jng.xyz/  http://13.70.5.151/cert/gjk1jng.xyz/privkey.pem
fi

set -e

sudo chmod -R 777 /docker/*

echo ">>start run nginx<<"
set +e
docker stop nginx
docker rm nginx
set -e
set +e
exist=`docker inspect --format '{{.State.Running}}' downFile`
if [ "${exist}" != "true" ]; then
docker run -d --net host --restart=always  -v /docker/nginx/confs/:/etc/nginx/conf.d/ -v /docker/nginx/logs/:/var/log/nginx/ -v /docker/nginx/www/:/etc/nginx/html/ --name nginx automsen/nginx:1.14.2
echo "nginx run success"
fi
set -e


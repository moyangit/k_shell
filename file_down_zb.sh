#!/bin/bash -e

if [ $# == 0 ] ; then
   echo "please input domain,example xx in 'xx.domain.com' 1:domainName, 2:force delete (1)"
   exit 0
fi

if [ $2 == 11 ]; then
  echo "deleting down file"
  sudo rm -rf /docker/nginx/www/down/
  sudo rm -rf /docker/nginx/
else
  echo "ingore down file"
fi

set +e
sudo apt install -y unzip
sudo yum install -y unzip
set -e
sudo mkdir -p /docker/nginx/www/down/

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
sudo docker pull moyandoc/nginx:1.14.2
echo "---end ------"

echo "---domain $1----"

#create file
sudo touch /docker/nginx/confs/down.conf

sudo chmod -R 777 /docker/*

#write nginx config into file
sudo cat > /docker/nginx/confs/down.conf << EOF

server {	
	listen       80;
  server_name  $1.d12d12.com;

	
	location / {
        root   /etc/nginx/html/down/;
    }
}

EOF

# set +e
# #auto config dns host
# exist=`docker inspect --format '{{.State.Running}}' ddns`
# echo "ddns contain $exist"
# if [ "${exist}" != "true" ]; 
# then
# docker run -d --name=ddns -e API_KEY=dd09d67522e7dfa49cde1048285fea534e6a8 -e ZONE=d12d12.com -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
# echo "ddns run success"
# else
# 	set +e
# 	docker stop ddns
# 	docker rm ddns
# 	set -e
# 	docker run -d --name=ddns -e API_KEY=dd09d67522e7dfa49cde1048285fea534e6a8 -e ZONE=d12d12.com -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
# 	echo "ddns run success"
# fi
# set -e


#down files to local
#hb file
set +e

sudo wget -O /docker/nginx/www/down/1.apk https://dw.kuxe2756.xyz/downpg/zb/ad

set -e

sudo chmod -R 777 /docker/*

echo ">>start run nginx<<"
set +e
docker stop down
docker rm down
set -e
set +e
exist=`docker inspect --format '{{.State.Running}}' down`
if [ "${exist}" != "true" ]; then
docker run -d -p 80:80 --restart=always  -v /docker/nginx/confs/:/etc/nginx/conf.d/ -v /docker/nginx/logs/:/var/log/nginx/ -v /docker/nginx/www/:/etc/nginx/html/ --name down moyandoc/nginx:1.14.2
echo "nginx run success"
fi
set -e


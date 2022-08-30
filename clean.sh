#!/bin/sh
#find /docker/nginx/logs/ -name '*.log' -exec cat /dev/null > {} \;
sudo cat /dev/null > /docker/nginx/logs/access.log;
sudo cat /dev/null > /docker/nginx/logs/error.log;
sudo cat /dev/null > /docker/tv2/logs/access.log;

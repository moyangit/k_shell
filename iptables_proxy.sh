#!/bin/bash
clear

# Linux 透明代理全局规则
# admin@cooluc.com
# 20220216

# 判断 root
if [ $EUID -ne 0 ];then
  echo -e "\033[31mError\033[0m: The systemd must be run as root." 1>&2
  exit 1;
fi

echo
echo "Linux 透明代理全局规则"
NOTE='\033[36m
==========================================================================
\r\n# 提示：本规则适合所有透明代理，默认通过IP-CIDR过滤国内IP\r\n
国内/香港：直连\r\n国外：代理\r\n
# v2ray 透明代理 inbounds 配置示例：
\033[0m\033[35m
    "inbounds": [{
        "tag": "transparent",
        "listen": "127.0.0.1",
        "port": 1080,
        "protocol": "dokodemo-door",
        "settings": {
            "network": "tcp,udp",
            "followRedirect": true
        },
        "streamSettings": null
    }],\033[0m\r\n\033[36m
==========================================================================
\033[0m';
echo -e "$NOTE";

APPLY() (
    echo -n "输入本地透明代理端口（范围 1-65535）："
    read TRANSPORT
    if [ -z $TRANSPORT ];then
      echo 输入错误，设置默认透明代理端口：1080
      TRANSPORT=1080
    fi

    echo -n "输入代理服务器IP（用于规则过滤）："
    read PROXY_IP
    if [ -z $PROXY_IP ];then
      echo "输入错误"
      exit 0;
    else
      RULE="\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[1-9])\b"
      CHECK_IP=`echo $PROXY_IP | egrep $RULE | wc -l`
      if [ $CHECK_IP -eq 0 ];then
        echo "IP 格式错误"
        exit 0;
      fi
    fi

    echo -n "路由转发状态："
    FORWARD_STATUS=`cat /proc/sys/net/ipv4/ip_forward`
    if [ $FORWARD_STATUS '==' "0" ]; then
        echo "未开启"
        echo "正在开启路由转发功能"
        sed -i '/ip_forward/d' /etc/sysctl.conf
        echo -e "\r\nnet.ipv4.ip_forward = 1" >> /etc/sysctl.conf
        sysctl -p
    elif [ $FORWARD_STATUS '==' "1" ]; then
        echo "已开启"
    fi

    # 禁用 firewalld 服务
    systemctl stop firewalld >/dev/null 2>&1
    systemctl mask firewalld >/dev/null 2>&1

    # 检查 iptables 是否安装
    if ! command -v iptables >/dev/null 2>&1; then
        echo 
        echo "iptables 未安装"
        echo
        exit 0;
    else
        if [ -f "/usr/bin/systemctl" ];then
            systemctl stop iptables
            systemctl start iptables
        else
            service iptables stop
            service iptables start
        fi
    fi

    # 检查 ipset 服务是否安装
    if [ ! -f "/lib/systemd/system/ipset.service" ];then
        echo 
        echo "ipset-service 未安装"
        echo
        exit 0;
    else
        if [ -f "/usr/bin/systemctl" ];then
            systemctl start ipset
            systemctl enable ipset >/dev/null 2>&1
        else
            service ipset start
            chkconfig --add ipset >/dev/null 2>&1
        fi
    fi

    echo "过滤 IP 段"
    # CN
    ipset destroy CN
    ipset create CN hash:net
    curl -s https://raw.cooluc.com/herrbischoff/country-ip-blocks/master/ipv4/cn.cidr > /tmp/CN.txt
    cat /tmp/CN.txt | xargs -I ip ipset add CN ip
    # HK
    #  ipset destroy HK
    #  ipset create HK hash:net
    #  curl -s https://raw.cooluc.com/herrbischoff/country-ip-blocks/master/ipv4/hk.cidr > /tmp/HK.txt
    #  cat /tmp/HK.txt | xargs -I ip ipset add HK ip
    service ipset save >/dev/null 2>&1

    echo "添加 iptables 防火墙规则"
    MYIP=$(ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1)
    if [[ "$MYIP" = "" ]]; then
        MYIP=$(curl -s http://ip.3322.net)
    fi

    # 清空 V2RAY 规则
    iptables -t nat -F V2RAY >/dev/null 2>&1
    iptables -t nat -D OUTPUT -p tcp -j V2RAY >/dev/null 2>&1
    iptables -t nat -D PREROUTING -p tcp -j V2RAY >/dev/null 2>&1
    iptables -t nat -X V2RAY >/dev/null 2>&1

    # 添加 V2RAY 链
    iptables -t nat -N V2RAY

    # 对局域网其他设备进行透明代理（适用于路由）
    # iptables -t nat -A PREROUTING -p tcp -j V2RAY

    # 对本机进行透明代理
    iptables -t nat -A OUTPUT -p tcp -j V2RAY

    # 过滤代理IP & 本机
    iptables -t nat -A V2RAY -d $PROXY_IP/32 -j RETURN
    iptables -t nat -A V2RAY -d $MYIP/32 -j RETURN

    # 直连内网 & 中国大陆IP段
    iptables -t nat -A V2RAY -d 0.0.0.0/8 -j RETURN
    iptables -t nat -A V2RAY -d 10.0.0.0/8 -j RETURN
    iptables -t nat -A V2RAY -d 127.0.0.0/8 -j RETURN
    iptables -t nat -A V2RAY -d 169.254.0.0/16 -j RETURN
    iptables -t nat -A V2RAY -d 172.16.0.0/12 -j RETURN
    iptables -t nat -A V2RAY -d 192.168.0.0/16 -j RETURN
    iptables -t nat -A V2RAY -d 224.0.0.0/4 -j RETURN
    iptables -t nat -A V2RAY -d 240.0.0.0/4 -j RETURN
    iptables -t nat -A V2RAY -p tcp -m set --match-set CN dst -j RETURN
    # iptables -t nat -A V2RAY -p tcp -m set --match-set HK dst -j RETURN

    # 流量转发（仅常用端口）
    iptables -t nat -A V2RAY -p tcp -m multiport --dports 21,22,587,465,995,993,143,80,443,853,9418 -j REDIRECT --to-ports $TRANSPORT

    # 保存规则
    iptables-save > /etc/sysconfig/iptables

    # 访问测试
    echo
    echo "访问测试"
    echo -e "国内站点：\e[1;32m$(curl -s -4 ip.3322.net)\e[0m";
    echo -e "国外站点：\e[1;32m$(curl -s -4 ip.sb)\e[0m";
    echo
)

DISABLE() (
    # 清空 NAT 规则
    iptables -t nat -F V2RAY >/dev/null 2>&1
    iptables -t nat -D OUTPUT -p tcp -j V2RAY >/dev/null 2>&1
    iptables -t nat -D PREROUTING -p tcp -j V2RAY >/dev/null 2>&1
    iptables -t nat -X V2RAY >/dev/null 2>&1
    ipset destroy CN >/dev/null 2>&1
    ipset destroy HK >/dev/null 2>&1
    echo
    echo "NAT规则已清除"
    echo

    # 保存规则
    iptables-save > /etc/sysconfig/iptables

    # 访问测试
    echo "访问测试"
    echo -e "国内站点：\e[1;32m$(curl -s -4 ip.3322.net)\e[0m";
    echo -e "国外站点：\e[1;32m$(curl -s -4 ip.sb)\e[0m";
    echo
)

RELAY() (
    # 读取网卡IP
    MYIP=$(ip addr | grep global | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -n 1)
    if [[ "$MYIP" = "" ]]; then
        MYIP=$(curl -s http://ip.3322.net)
    fi
    echo 
    echo -n "请输入国外IP：";read GLOBAL
    echo -n "请输入国外端口：";read GLOBAL_PROT
    echo -n "请输入本机通讯端口：";read LOCAL_PROT
    echo 

    echo -n "路由转发状态："
    FORWARD_STATUS=`cat /proc/sys/net/ipv4/ip_forward`
    if [ $FORWARD_STATUS '==' "0" ]; then
      echo "未开启"
      echo "正在开启路由转发功能"
      sed -i '/ip_forward/d' /etc/sysctl.conf
      echo -e "\r\nnet.ipv4.ip_forward = 1" >> /etc/sysctl.conf
      sysctl -p
    elif [ $FORWARD_STATUS '==' "1" ]; then
      echo "已开启"
    fi

    # 端口转发
    iptables -t nat -A PREROUTING -p tcp -m tcp --dport $LOCAL_PROT -j DNAT --to-destination $GLOBAL:$GLOBAL_PROT
    iptables -t nat -A PREROUTING -p udp -m udp --dport $LOCAL_PROT -j DNAT --to-destination $GLOBAL:$GLOBAL_PROT
    iptables -t nat -A POSTROUTING -d $GLOBAL -p tcp -m tcp --dport $GLOBAL_PROT -j SNAT --to-source $MYIP
    iptables -t nat -A POSTROUTING -d $GLOBAL -p udp -m udp --dport $GLOBAL_PROT -j SNAT --to-source $MYIP

    # 保存规则
    iptables-save > /etc/sysconfig/iptables

    echo -e "已经添加转发规则：\033[36m$MYIP\033[0m:\033[36m$LOCAL_PROT\033[0m -> \033[36m$GLOBAL\033[0m:\033[36m$GLOBAL_PROT\033[0m"
    echo 
)

echo
echo "> 请选择："
echo
echo " 1 - 应用全局代理规则" 
echo " 2 - 清除代理规则"
echo
echo " 3 - iptables 中继国外服务器（TCP & udp）"
echo
echo -n "请输入："
read mode
case $mode in
[1]|[1-3]) ;;
*) echo -e '\n ...输入错误.';exit 0;;
esac
if [ -z $mode ]
    then
    echo -e '\n ...输入错误.';exit 0;
else
    if [[ $mode == "1" ]];then
        APPLY
    elif [[ $mode == "2" ]];then
        DISABLE
    elif [[ $mode == "3" ]];then
        RELAY
    fi
fi

#!/bin/bash -e

if [ $# == 0 ] ; then
   echo "please input params, 参数1 eth0(网卡)，参数2 限制流量，322122547200(300G) 429496729600(400G) 536870912000(500G) 858993459200(800G) 1099511627776(1T)"
   exit 0
fi

#初始化data.json
if [ ! -f "data.json" ];then
	timeTmp=`date +%Y%m%d`
	firstUpFlowValTmp=$3
	lastData='{"time":'$timeTmp',"firstUpFlowVal":0}'
	echo $lastData > data.json
fi

sudo curl -L ip.tool.lu > ip.log
ipAddr=0
while read line
do
     ipAddr=$line
     break
 done < ip.log

while [ "1" ]
do
eth=$1
RX=$(cat /proc/net/dev | grep $eth | tr : " " | awk '{print $2}')
TX=$(cat /proc/net/dev | grep $eth | tr : " " | awk '{print $10}')

#获取data.json文件，匹配今日时间和 今日初始流量，如果是今日，当前流量-今日初始流量 > 限制流量 则停止，如果是次日，更新data.json

time=$(cat data.json | sed 's/,/\n/g' | grep "time" | sed 's/:/\n/g'|sed '1d' | sed 's/}//g')
firstUpFlowVal=$(cat data.json | sed 's/,/\n/g' | grep "firstUpFlowVal" | sed 's/:/\n/g'|sed '1d' | sed 's/}//g')

msg="`date +%Y%m%d%k:%M:%S`,down:${RX},up:${TX},limit:$2,"$ipAddr
#去掉所有空格
#msg=${msg// /}
msg=$msg | sed 's/ //g'
echo $msg >> traff.log

timeTmp1=`date +%Y%m%d`
#如果是今日，比较流量
if [ ${time} -eq ${timeTmp1} ] ; then
   echo "today compare, firstUpFlowVal : ${firstUpFlowVal}, currUpFlowVal: ${TX} " >> traff.log
   
   diff=`expr $TX - $firstUpFlowVal`
   
   #如果当日使用流量大于设置的限制流量就停服务
   if [ $diff -ge $2 ] ; then
	   echo "--stoping and stoped up flow more limit, TX:${TX}, DIFF:${diff}" >> traff.log
	   #处理curl中文字符问题
	   msg="[stoped] ${msg}"
	   urlEncodeMsg=`echo -n "$msg" | xxd -ps | tr -d '\n' | sed -r 's/(..)/%\1/g'`;
	   notifyUrl="https://api.telegram.org/bot2119459424:AAFYV9ZuGV3GsUinUbvt8iGXUvDf_QYNnYo/sendMessage?chat_id=1373459932&text="$urlEncodeMsg
	   echo $notifyUrl
	   sudo curl $notifyUrl
	   set +e
	   sudo docker stop tpr
	   sudo docker stop tv2
	   set -e
	   echo "stoped sleep 0.5 hour..." >> traff.log
	   sleep 1800 
	   continue
   fi
   
   #如果当日大于限制流量的80% 就报警，不停服务器
   calcb=$(($2*80/100)) 
   if [ $diff -ge $calcb ] ; then
	   echo "--warning up flow more limit, TX : ${TX}, DIFF:${diff}" >> traff.log
	   #处理curl中文字符问题
	   msg="[warn] ${msg}"
	   urlEncodeMsg=`echo -n "$msg" | xxd -ps | tr -d '\n' | sed -r 's/(..)/%\1/g'`;
	   notifyUrl="https://api.telegram.org/bot2119459424:AAFYV9ZuGV3GsUinUbvt8iGXUvDf_QYNnYo/sendMessage?chat_id=1373459932&text="$urlEncodeMsg
	   echo $notifyUrl
	   sudo curl $notifyUrl
	   echo "warning sleep 0.5 hour..." >> traff.log
	   sleep 1800 

   fi
   

fi

#如果是次日，更新data.json， 同时重启docker
if [ ${time} -lt ${timeTmp1} ] ; then
	   echo "reset....." >> traff.log
	   lastData='{"time":'$timeTmp1',"firstUpFlowVal":'$TX'}'
	   echo $lastData > data.json
	   set +e
	   sudo docker start tpr
	   sudo docker start tv2
	   set -e
fi

sleep 5
done
e

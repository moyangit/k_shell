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
sudo mkdir -p /docker/nginx/confs/cert/d12d12.com/
sudo touch /docker/nginx/confs/cert/d12d12.com/fullchain.pem
sudo touch /docker/nginx/confs/cert/d12d12.com/privkey.pem
sudo chmod -R 777 /docker/nginx/
sudo cat > /docker/nginx/confs/cert/d12d12.com/fullchain.pem << EOF
-----BEGIN CERTIFICATE-----
MIIE5DCCA8ygAwIBAgISBMYcNllaHYuQXJTF7D7sus/eMA0GCSqGSIb3DQEBCwUA
MDIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MQswCQYDVQQD
EwJSMzAeFw0yMzA2MjQxMTUxNTJaFw0yMzA5MjIxMTUxNTFaMBcxFTATBgNVBAMM
DCouZDEyZDEyLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMDq
ixsu9YFqyqfDx/pnltGBIqWGqwhIKY36Zn8YxTI9gVhXwrE4gf+ZQG5PLN0eIhnS
h/oTpvh4mybUAn7mXxeFSNVYF2RAbAQTx9oDOmN0335UZrvqv2r1QQFucWIPyotp
QByHjazBAdPZKZ5tEU5Z7uZUj1NDHKnwHktSjhczrNkwcecEzArUfNKKTTgBdMvs
w5Rzk2+VU7nkMHgKxbvFolN3kcDp67Pd4r27BrPjK3JMdtKQWPMEmoWlyRkC82li
PT85bxavWMy8PBW7LnT0O5CYFOOeQVPNTQG2uyTJXCntTyWlw/QTaNpZVOgmYqZh
vbXCyV0t0EhtBRmDcakCAwEAAaOCAg0wggIJMA4GA1UdDwEB/wQEAwIFoDAdBgNV
HSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAdBgNVHQ4E
FgQUP6Hl1q6DboNNOSJk7FEXbn4eZiwwHwYDVR0jBBgwFoAUFC6zF7dYVsuuUAlA
5h+vnYsUwsYwVQYIKwYBBQUHAQEESTBHMCEGCCsGAQUFBzABhhVodHRwOi8vcjMu
by5sZW5jci5vcmcwIgYIKwYBBQUHMAKGFmh0dHA6Ly9yMy5pLmxlbmNyLm9yZy8w
FwYDVR0RBBAwDoIMKi5kMTJkMTIuY29tMBMGA1UdIAQMMAowCAYGZ4EMAQIBMIIB
AwYKKwYBBAHWeQIEAgSB9ASB8QDvAHYAejKMVNi3LbYg6jjgUh7phBZwMhOFTTvS
K8E6V6NS61IAAAGI7XX7oAAABAMARzBFAiEA33hC1MBE2H5w6QqAunbdGocvScQG
J2vSV2XyR/JL+SoCIGqUkXAkWkbw/AnzB+ccQlrKshOTTd9GpL7BN0oDfZieAHUA
rfe++nz/EMiLnT2cHj4YarRnKV3PsQwkyoWGNOvcgooAAAGI7XX7/wAABAMARjBE
AiAdeoPtWlyi2EKEdlUrTy39ngpcAu/11lw7m5plPZJ0gwIgLRLf+pCv/6/uKGo0
UNAnjQMW26vo7riPeIiAsXUHgZkwDQYJKoZIhvcNAQELBQADggEBABnfu0dqbhrg
nFT1VlTDlsqHMY5XH1tG3C9esujHJhzvLWduZCdhP9b5p9AeRnHwPjsnysQpLEva
BwRtWuNUiwfBrZKbt3xwtSWWCvbTCHys4eFMljKhUDRgDBoeYLvssdYZ3utNRTTu
bd3Wtds7UXk0qOxafyNjgRPup55PrTb4bC2lHqGW7DR0Q9yaZvD8g8tSRoEoxfUL
EYtytWD4J0YVZh/N52AcsGkUrSA1HLVVE6DPmilQ7wdQ2U8oVSZBrqSNiaBHLhHP
S5djivmeSF0SczyKD5pufnJmfPAb0YbHxabuLMCYWk8sH+X1ntSLARQTgt2UAzbh
9w3bCVrLA8c=
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFFjCCAv6gAwIBAgIRAJErCErPDBinU/bWLiWnX1owDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMjAwOTA0MDAwMDAw
WhcNMjUwOTE1MTYwMDAwWjAyMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNTGV0J3Mg
RW5jcnlwdDELMAkGA1UEAxMCUjMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQC7AhUozPaglNMPEuyNVZLD+ILxmaZ6QoinXSaqtSu5xUyxr45r+XXIo9cP
R5QUVTVXjJ6oojkZ9YI8QqlObvU7wy7bjcCwXPNZOOftz2nwWgsbvsCUJCWH+jdx
sxPnHKzhm+/b5DtFUkWWqcFTzjTIUu61ru2P3mBw4qVUq7ZtDpelQDRrK9O8Zutm
NHz6a4uPVymZ+DAXXbpyb/uBxa3Shlg9F8fnCbvxK/eG3MHacV3URuPMrSXBiLxg
Z3Vms/EY96Jc5lP/Ooi2R6X/ExjqmAl3P51T+c8B5fWmcBcUr2Ok/5mzk53cU6cG
/kiFHaFpriV1uxPMUgP17VGhi9sVAgMBAAGjggEIMIIBBDAOBgNVHQ8BAf8EBAMC
AYYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMBMBIGA1UdEwEB/wQIMAYB
Af8CAQAwHQYDVR0OBBYEFBQusxe3WFbLrlAJQOYfr52LFMLGMB8GA1UdIwQYMBaA
FHm0WeZ7tuXkAXOACIjIGlj26ZtuMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcw
AoYWaHR0cDovL3gxLmkubGVuY3Iub3JnLzAnBgNVHR8EIDAeMBygGqAYhhZodHRw
Oi8veDEuYy5sZW5jci5vcmcvMCIGA1UdIAQbMBkwCAYGZ4EMAQIBMA0GCysGAQQB
gt8TAQEBMA0GCSqGSIb3DQEBCwUAA4ICAQCFyk5HPqP3hUSFvNVneLKYY611TR6W
PTNlclQtgaDqw+34IL9fzLdwALduO/ZelN7kIJ+m74uyA+eitRY8kc607TkC53wl
ikfmZW4/RvTZ8M6UK+5UzhK8jCdLuMGYL6KvzXGRSgi3yLgjewQtCPkIVz6D2QQz
CkcheAmCJ8MqyJu5zlzyZMjAvnnAT45tRAxekrsu94sQ4egdRCnbWSDtY7kh+BIm
lJNXoB1lBMEKIq4QDUOXoRgffuDghje1WrG9ML+Hbisq/yFOGwXD9RiX8F6sw6W4
avAuvDszue5L3sz85K+EC4Y/wFVDNvZo4TYXao6Z0f+lQKc0t8DQYzk1OXVu8rp2
yJMC6alLbBfODALZvYH7n7do1AZls4I9d1P4jnkDrQoxB3UqQ9hVl3LEKQ73xF1O
yK5GhDDX8oVfGKF5u+decIsH4YaTw7mP3GFxJSqv3+0lUFJoi5Lc5da149p90Ids
hCExroL1+7mryIkXPeFM5TgO9r0rvZaBFOvV2z0gp35Z0+L4WPlbuEjN/lxPFin+
HlUjr8gRsI3qfJOQFy/9rKIJR0Y/8Omwt/8oTWgy1mdeHmmjk7j1nYsvC9JSQ6Zv
MldlTTKB3zhThV1+XWYp6rjd5JW1zbVWEkLNxE7GJThEUG3szgBVGP7pSWTUTsqX
nLRbwHOoq7hHwg==
-----END CERTIFICATE-----
-----BEGIN CERTIFICATE-----
MIIFYDCCBEigAwIBAgIQQAF3ITfU6UK47naqPGQKtzANBgkqhkiG9w0BAQsFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTIxMDEyMDE5MTQwM1oXDTI0MDkzMDE4MTQwM1ow
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwggIiMA0GCSqGSIb3DQEB
AQUAA4ICDwAwggIKAoICAQCt6CRz9BQ385ueK1coHIe+3LffOJCMbjzmV6B493XC
ov71am72AE8o295ohmxEk7axY/0UEmu/H9LqMZshftEzPLpI9d1537O4/xLxIZpL
wYqGcWlKZmZsj348cL+tKSIG8+TA5oCu4kuPt5l+lAOf00eXfJlII1PoOK5PCm+D
LtFJV4yAdLbaL9A4jXsDcCEbdfIwPPqPrt3aY6vrFk/CjhFLfs8L6P+1dy70sntK
4EwSJQxwjQMpoOFTJOwT2e4ZvxCzSow/iaNhUd6shweU9GNx7C7ib1uYgeGJXDR5
bHbvO5BieebbpJovJsXQEOEO3tkQjhb7t/eo98flAgeYjzYIlefiN5YNNnWe+w5y
sR2bvAP5SQXYgd0FtCrWQemsAXaVCg/Y39W9Eh81LygXbNKYwagJZHduRze6zqxZ
Xmidf3LWicUGQSk+WT7dJvUkyRGnWqNMQB9GoZm1pzpRboY7nn1ypxIFeFntPlF4
FQsDj43QLwWyPntKHEtzBRL8xurgUBN8Q5N0s8p0544fAQjQMNRbcTa0B7rBMDBc
SLeCO5imfWCKoqMpgsy6vYMEG6KDA0Gh1gXxG8K28Kh8hjtGqEgqiNx2mna/H2ql
PRmP6zjzZN7IKw0KKP/32+IVQtQi0Cdd4Xn+GOdwiK1O5tmLOsbdJ1Fu/7xk9TND
TwIDAQABo4IBRjCCAUIwDwYDVR0TAQH/BAUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYw
SwYIKwYBBQUHAQEEPzA9MDsGCCsGAQUFBzAChi9odHRwOi8vYXBwcy5pZGVudHJ1
c3QuY29tL3Jvb3RzL2RzdHJvb3RjYXgzLnA3YzAfBgNVHSMEGDAWgBTEp7Gkeyxx
+tvhS5B1/8QVYIWJEDBUBgNVHSAETTBLMAgGBmeBDAECATA/BgsrBgEEAYLfEwEB
ATAwMC4GCCsGAQUFBwIBFiJodHRwOi8vY3BzLnJvb3QteDEubGV0c2VuY3J5cHQu
b3JnMDwGA1UdHwQ1MDMwMaAvoC2GK2h0dHA6Ly9jcmwuaWRlbnRydXN0LmNvbS9E
U1RST09UQ0FYM0NSTC5jcmwwHQYDVR0OBBYEFHm0WeZ7tuXkAXOACIjIGlj26Ztu
MA0GCSqGSIb3DQEBCwUAA4IBAQAKcwBslm7/DlLQrt2M51oGrS+o44+/yQoDFVDC
5WxCu2+b9LRPwkSICHXM6webFGJueN7sJ7o5XPWioW5WlHAQU7G75K/QosMrAdSW
9MUgNTP52GE24HGNtLi1qoJFlcDyqSMo59ahy2cI2qBDLKobkx/J3vWraV0T9VuG
WCLKTVXkcGdtwlfFRjlBz4pYg1htmf5X6DYO8A4jqv2Il9DjXA6USbW1FzXSLr9O
he8Y4IWS6wY7bCkjCWDcRQJMEhg76fsO3txE+FiYruq9RUWhiF1myv4Q6W+CyBFC
Dfvp7OOGAN6dEOM4+qR9sdjoSYKEBpsr6GtPAQw4dy753ec5
-----END CERTIFICATE-----
EOF

sudo cat > /docker/nginx/confs/cert/d12d12.com/privkey.pem << EOF
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDA6osbLvWBasqn
w8f6Z5bRgSKlhqsISCmN+mZ/GMUyPYFYV8KxOIH/mUBuTyzdHiIZ0of6E6b4eJsm
1AJ+5l8XhUjVWBdkQGwEE8faAzpjdN9+VGa76r9q9UEBbnFiD8qLaUAch42swQHT
2SmebRFOWe7mVI9TQxyp8B5LUo4XM6zZMHHnBMwK1HzSik04AXTL7MOUc5NvlVO5
5DB4CsW7xaJTd5HA6euz3eK9uwaz4ytyTHbSkFjzBJqFpckZAvNpYj0/OW8Wr1jM
vDwVuy509DuQmBTjnkFTzU0BtrskyVwp7U8lpcP0E2jaWVToJmKmYb21wsldLdBI
bQUZg3GpAgMBAAECggEBAKW/HeMuFmqpyRIYqNFgfPjlXVIgAQRtk55TXAqoyoxe
wamYRUMkTLTBA9WCmwYjpKLQ+lkG13c1j//tOXO0FFFOB4SdWgOdQfDC2ftauKjI
ulh8xYOArhOEQeSr8iiRbrEWramVYUjizuIn+5UNGkhaBmLIlhewWok7L5wBguk0
0YBhpJA3HYHHcxIJw9tKbz7/tAmOsvoom9bo/Om3derc4jGvUfHfOzhMd7u7/F3T
wWufaN8/0eIt6YeYhbngfNQk1WkqBdlP3X1JuaAqUislRgaTUgRiIH9r38NtByfB
BlYQfotKJQI4/8U/qO6ff8rTSPb/mQoaV4mGSmRQ1r0CgYEA+DlJT4Vk22annIZw
tFRlT+prnSfdUNlA6ldBOgaGUVv356N1acDSTsnXnOqDePsKpYuJ9wTo0lWUwkTc
tb9WWLaN5/rxHQHL8VjkZWt4viGPOvbHTnxR8Z+zjAGyKNiP9SRDrc1APy4GiSJw
A8Vz8UwuuDc8au3GiuaFaKB1bJcCgYEAxvWzBJo2RqXjuBOg7KUA1UKyAbSWKq/Y
uoPq8sHvK/qRSar+7zkF05xZUa1IQcqvi1ZZlPSJmaM3Z9/0KneqoxIB6e7QurVx
4Pmun/dyHc8jp5g5AWZ5ehMOpDN+jAdz9y1+zKbX5fLtxXO+Y1V6woYujHS3K79f
6ppeWR0Ym78CgYBVyK5+TfJqJJL+dDPVDmmo8bHZMSK6Qyq9EgSXwhN/YJJPOl1k
e9/ynKzoLN/c2p12UsAOX2L69dqgPN4t7X8wz35BUqcrSCisMvVT241x3/U5Anok
tLA5GeEaHKful9FAfhTppspySzy0/fLKSt3j4VkwDt7RcXUxIbOvUezi5wKBgCEO
p8zm9oesfnaSRFWtYMMOTtc7swuqpf7vdjUZheyvuD4ePDdxKQes3aZVfUD5NUuY
cE/whYBSfx0yN7ZqpZ5smobM2D99cEtqENqhWYOcbBcnkqkp5psi2Xbs22TWxCzY
kU3dltetElaRUZvdkwUJGGjb56dMJ9qqBW0XCYSvAoGBAKOgUzDyfYGigI8eechy
At+fdBKofRB+v1+EmQrR8XcPdrMSS3E4DWGpxG6ru5jMUpZtwr9ibZI2rdcyr76J
LBD8CAnL6Lbdnw6juvmUCKwvd3qdoThCbxuXbFqC6lBAvGkjCZyzx/6d6jv2fDPa
5CdDA4khCA9GSVvKV4REnaRX
-----END PRIVATE KEY-----
EOF

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
sudo mkdir -p /docker/nginx/confs/
sudo touch /docker/nginx/confs/down.conf

sudo chmod -R 777 /docker/*

#write nginx config into file
sudo cat > /docker/nginx/confs/down.conf << EOF

server {    
    listen       443;
    server_name  $1.d12d12.com;
    ssl on;
    ssl_certificate /etc/nginx/conf.d/cert/d12d12.com/fullchain.pem;
    ssl_certificate_key /etc/nginx/conf.d/cert/d12d12.com/privkey.pem;

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

# set +e
# #auto config dns host
# exist=`docker inspect --format '{{.State.Running}}' ddns`
# echo "ddns contain $exist"
# if [ "${exist}" != "true" ]; 
# then
# docker run -d --name=ddns -e API_KEY=dd09d67522e7dfa49cde1048285fea534e6a8 -e ZONE=d12d12.com -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
# echo "ddns run success"
# else
#       set +e
#       docker stop ddns
#       docker rm ddns
#       set -e
#       docker run -d --name=ddns -e API_KEY=dd09d67522e7dfa49cde1048285fea534e6a8 -e ZONE=d12d12.com -e SUBDOMAIN=$1 --restart=always oznu/cloudflare-ddns
#       echo "ddns run success"
# fi
# set -e


#down files to local
#hb file
set +e
    
# sudo wget -O /docker/nginx/www/down/1.apk https://dw.kuxe2756.xyz/downpg/zb/ad

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
docker run -d -p 443:443 -p 80:80 --restart=always  -v /docker/nginx/confs/:/etc/nginx/conf.d/ -v /docker/nginx/logs/:/var/log/nginx/ -v /docker/nginx/www/:/etc/nginx/html/ --name down moyandoc/nginx:1.14.2
echo "nginx run success"
fi
set -e

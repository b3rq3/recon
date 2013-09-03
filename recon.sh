#!/usr/bin/env sh
#
# Date="Tue 2013-09-03 "
# Author="bq"
#
# License:
# Free as in free beer.
# For legal purposes only. User take full responsibility for any actions performed using this script.
# The author accepts no liablity for damage caused by this tool. 
# 
# credits to:
# http://blog.g0tmi1k.com/2011/08/basic-linux-privilegescalation.html

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# TODO:
# check mysql and postgres for root login without password


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# maybe you need a real shell 
# python -c 'import pty;pty.spawn("/bin/bash")'
# echo os.system('/bin/bash')
# /bin/sh -i

#BULLSHIT =  2>/dev/null 

usage () {
	echo "-s | output to stdout"
	echo "-o  /path/your.txt | will write the output to your.txt"

}

recon () {

echo  '\n'
echo  '|---------------------------------------------------------------|'
echo  '               distribution and kernel version                   '
echo  '|---------------------------------------------------------------|\n'
cat /etc/issue
uname -a 
ls /boot/vmlinuz*
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '\n'
echo  '|---------------------------------------------------------------|'
echo  '                    mount and diskusage '
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::::::::: mount -l :::::::::::::::::::::::::::::::::::::: '
mount -l 
echo  '\n'
echo ':::::::::::::::::::::::::: dh -h ::::::::::::::::::::::::::::::::::::::: '
df -h 
echo  '\n'
echo '::::::::::::::::::::::::: cat /etc/fstab :::::::::::::::::::::::::::::::::::::::: '
cat /etc/fstab
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

#redundant info -> installed packages
#echo Development tools availability
#which gcc
#which g++
#which python
#which perl
#which ruby
#which lua


echo  '\n\n'
echo  '|---------------------------------------------------------------|'
echo  '                    network '
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::::: netstat -tulpen :::::::::::::::::::::::::::::::::::::::::: '
netstat -tulpen
echo  '\n'
echo '::::::::::::::::::::::: ip a :::::::::::::::::::::::::::::::::::::::::: '
ip a
echo  '\n'
echo ':::::::::::::::::::::::: ip route show ::::::::::::::::::::::::::::::::::::::::: '
ip route show
echo  '\n'
echo ':::::::::::::::::::::::: cat /etc/hosts ::::::::::::::::::::::::::::::::::::::::: '
cat /etc/hosts
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '\n\n'
echo  '|---------------------------------------------------------------|'
echo  '                    ps aux '
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '
ps aux
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '\n\n'
echo  '|---------------------------------------------------------------|'
echo  '                    scheduled jobs '
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::: /etc/cron* :::::::::::::::::::::::::::::::::::::::::::: '
find /etc/cron* -ls 2>/dev/null
echo  '\n'
echo ':::::::::::::::::::::::: /var/spool/cron* ::::::::::::::::::::::::::::::::::::::::: '
find /var/spool/cron* -ls 2>/dev/null
echo  '\n'
echo ':::::::::::::::::::::::: crontab -l :::::::::::::::::::::::::::::::::::::::: '
crontab -l
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '\n\n'
echo  '|---------------------------------------------------------------|'
echo  '                    readable files in /etc '
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '
find /etc -user `id -u` -perm -u=r -o -group `id -g` -perm -g=r -o -perm -o=r -ls 2>/dev/null
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '\n\n'
echo  '|---------------------------------------------------------------|'
echo  '                   global suid and guid writable files'
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '
find / -o -group `id -g` -perm -g=w -perm -u=s -o -perm -o=w -perm -u=s -o -perm -o=w -perm -g=s -ls 2>/dev/null
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

#dangerous ~~~> disk can be noisy.
#echo Writable files outside HOME
#mount -l find / -path “$HOME” -prune -o -path “/proc” -prune -o \( ! -type l \) \( -user `id -u` -perm -u=w  -o -group `id -g` -perm -g=w  -o -perm -o=w \) -ls 2>/dev/null

echo  '\n\n'
echo  '|---------------------------------------------------------------|'
echo  '                    printers'
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '
lpstat -a
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '|---------------------------------------------------------------|'
echo  '                    users and groups'
echo  '|---------------------------------------------------------------|'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '
echo  '\n'
echo  '\n\n'
echo ':::::::::::::::::: id u g::::::::::::::::::::::::::::::::::::::::::::::: '
id -u 
id -g
echo  '\n'
echo ':::::::::::::::::::: last ::::::::::::::::::::::::::::::::::::::::::::: '
last
echo  '\n'
echo '::::::::::::::::::::: w  :::::::::::::::::::::::::::::::::::::::::::: '
w
echo  '\n'
echo '::::::::::::::::::::: /etc/group :::::::::::::::::::::::::::::::::::::::::::: '
cat /etc/group
echo  '\n'
echo ':::::::::::::::::::::: /etc/passwd ::::::::::::::::::::::::::::::::::::::::::: '
cat /etc/passwd
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '\n\n'
echo  '|---------------------------------------------------------------|'
echo  '                    webfiles'
echo  '|---------------------------------------------------------------|'
echo ':::::::::::::::::::: /var/www ::::::::::::::::::::::::::::::::::::::::::::: '
ls -alhR /var/www/*
echo  '\n'
echo '::::::::::::::::::::: /srv/www/htdocs :::::::::::::::::::::::::::::::::::::::::::: '
ls -alhR /srv/www/htdocs/
echo  '\n'
echo '::::::::::::::::::::: /usr/local/www/apache22/data  :::::::::::::::::::::::::::::::::::::::::::: '
ls -alhR /usr/local/www/apache22/data/
echo  '\n'
echo ':::::::::::::::::::::: /opt/lampp/htdocs ::::::::::::::::::::::::::::::::::::::::::: '
ls -alhR /opt/lampp/htdocs/
echo  '\n'
echo '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: '

echo  '\n'
echo  '|---------------------------------------------------------------|'
echo  '                    installed packages '
echo  '|---------------------------------------------------------------|'

if [  /usr/bin/dpkg ]; then

	dpkg -l | awk '{print $2 " "  $3}'
else
	rpm -qa
fi

exit 0
}


case "$1" in
	-o)
		recon >$2
		;;
	-s)
		recon
		;;
	*)
		usage
		exit 0
		;;
esac



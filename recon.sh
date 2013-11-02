#!/usr/bin/env sh
#
# Date="Tue 2013-09-03 "
# Author="bq"
#
# License:
# The MIT License (MIT)
# For legal purposes only. User take full responsibility for any actions performed using this script.
#  
# 
# credits to:
# http://blog.g0tmi1k.com/2011/08/basic-linux-privilegescalation.html
# http://www.tldp.org/HOWTO/Security-HOWTO/file-security.html

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# TODO:
# check mysql and postgres for root login without password


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# maybe you need a real shell 
# python -c 'import pty;pty.spawn("/bin/bash")'
# echo os.system('/bin/bash')
# /bin/sh -i


usage() {
	echo "-s | output to stdout"
	echo "-o  /path/your.txt | will write the output to your.txt"

}

infoprint() {
	divider="|------------------------------------------------------------------|"
	t="\n %40s \n"
	printf "$divider"
	printf "$t" "$1"
	printf "$divider\n"
}

commandinfo() {
	t="%10s\n"
	printf "$t" "::::::::::::::::::::::::::" "$1" "::::::::::::::::::::::::::"
}

# this works only in bash
#divider() {
#	printf -v d "%80s" "" 
#	printf "%s\n" "${d// /_}"
#}

recon() {

infoprint "Distribution and Kernel Info"
cat /etc/issue
uname -a 
ls /boot/vmlinuz*

infoprint "mount and diskusage"
commandinfo "mount -l"
mount -l 
commandinfo "df -h"
df -h 
commandinfo "cat /etc/fstab"
cat /etc/fstab

infoprint "network"
commandinfo "netstat -tulpen"
netstat -tulpen
commandinfo "ip a"
ip a
commandinfo "ip route show"
ip route show
commandinfo "cat /etc/hosts"
cat /etc/hosts

infoprint "processes"
ps aux

infoprint "scheduled jobs"
commandinfo "find /etc/cron*"
find /etc/cron* -ls 2>/dev/null
commandinfo "/var/spool/cron*"
find /var/spool/cron* -ls 2>/dev/null
commandinfo "crontab -l"
crontab -l 2>/dev/null

infoprint "readable files in /etc"
find /etc -user `id -u` -perm -u=r -o -group `id -g` -perm -g=r -o -perm -o=r -ls 2>/dev/null

infoprint "global suid and guid writable files"
find / -group `id -g` -perm -g=w -perm -u=s -o -perm -o=w -perm -u=s -o -perm -o=w -perm -g=s -ls 2>/dev/null

## just in case you need more verbose information: 
##  all suid/sgid files
# find / -type f \( -perm -04000 -o -perm -02000 \) -ls 2>/dev/null

## world writable files 
# find / -perm -2 ! -type l -ls 2>/dev/null

#dangerous ~~~> disk can be noisy.
#echo Writable files outside HOME
#mount -l find / -path “$HOME” -prune -o -path “/proc” -prune -o \( ! -type l \) \( -user `id -u` -perm -u=w  -o -group `id -g` -perm -g=w  -o -perm -o=w \) -ls 2>/dev/null

infoprint "printers"
lpstat -a

infoprint "users and groups"
commandinfo "id u g"
id -u 
id -g
commandinfo "last"
last
commandinfo "w"
w
commandinfo "/etc/group"
cat /etc/group
commandinfo "/etc/group"
cat /etc/passwd

infoprint "webfiles"
commandinfo "ls -alhR /var/www"
ls -alhR /var/www/* 2>/dev/null 
commandinfo "ls -alhR /srv/www/htdocs"
ls -alhR /srv/www/htdocs/ 2>/dev/null
commandinfo "ls -alhR /usr/local/www/apache22/data"
ls -alhR /usr/local/www/apache22/data/ 2>/dev/null
commandinfo "ls -alhR /opt/lampp/htdocs"


infoprint "installed packages"
if [  /usr/bin/dpkg ]; then

	dpkg -l | awk '{print $2 " "  $3}'
else
	rpm -qa
fi

commandinfo "end of recon"

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



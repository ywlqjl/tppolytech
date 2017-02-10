#!/bin/bash

AWK=/usr/bin/awk
CAT=/bin/cat
TR=/usr/bin/tr

DOCKER_COMPOSE_VERSION="1.11.1"

function CheckSudo()
{
	if [[ -z "${SUDO_USER}" ]]; then
		echo "Please run script with sudo !!"
		exit 1
	fi
}

function CheckDistrib()
{
	local LSBR=/usr/bin/lsb_release
	CODENAME="undefined"


	if [[ -x "${LSBR}" ]]; then
		DIST=$(${LSBR} -i|${AWK} '{print $NF}'|${TR} '[:upper:]' '[:lower:]')
		RELEASE=$(${LSBR} -r|${AWK} '{print $NF}')
		CODENAME=$(${LSBR} -c|${AWK} '{print $NF}')
	fi

	if [[ -e '/etc/redhat-release' ]]; then
		DIST=$(${CAT} /etc/redhat-release|${AWK} '{print $1}'|${TR} '[:upper:]' '[:lower:]')
		RELEASE=$(${CAT} /etc/redhat-release|${AWK} '{print $3}')
	fi

	DIST=$(echo "${DIST}")
}

function gecho()
{
	echo -e "\e[1;32m -> ${1} \e[0m"
}

CheckSudo

CheckDistrib

#echo ${DIST}
#echo ${RELEASE}
#echo ${CODENAME}

#exit 0

gecho "run apt-get update"
apt-get update

gecho "run apt-get install apt-transport-https ca-certificates"
apt-get -y install apt-transport-https ca-certificates

gecho "purging lxc-docker."
gecho "add repo's key"
case "${DIST}" in
	ubuntu)
		apt-get -y purge lxc-docker
		apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	;;
	debian)
		apt-get -y purge lxc-docker*
		apt-get -y purge docker.io*
		apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	;;
esac

echo "deb https://apt.dockerproject.org/repo ${DIST}-${CODENAME} main" | tee /etc/apt/sources.list.d/docker.list

gecho "run apt-get update"
apt-get update

gecho "this is docker-engine policy"
apt-cache policy docker-engine

gecho "run apt-get install linux-image-extra-$(uname -r)"
apt-get -y install linux-image-extra-$(uname -r)

#gecho "run apt-get install apparmor"
#apt-get -y install apparmor

gecho "run apt-get installi docker-engine"
apt-get -y install docker-engine

gecho "promote user to run docker"
usermod -aG docker ${SUDO_USER}

gecho "docker restart"
service docker restart


gecho "update grub"
cp /etc/default/grub /etc/default/grub.original
sed -i 's/^GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"/' /etc/default/grub 
update-grub

curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


gecho "docker version"
docker --version

gecho "docker-compose version"
docker-compose --version

gecho "Done"
gecho "You mau need to reboot"
#reboot

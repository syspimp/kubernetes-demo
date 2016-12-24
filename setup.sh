#!/bin/bash

function msg {
  local RCol='\e[0m'
  local Red='\e[0;31m'
  echo -e "\n${Red}** $*${RCol}"
  sleep 3
}

msg Disabling firewalld, adding a rule for the docker registry
systemctl disable firewalld
systemctl stop firewalld
# to do, convert to selinux
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 5000 -j ACCEPT
echo 'iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 5000 -j ACCEPT' >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local


echo msg Subscribing to rhn (optional, just echoing commands)
echo subscription-manager register --serverurl=https://subscription.rhn.redhat.com --auto-attach
echo subscription-manager attach
echo subscription-manager repos --disable=*
echo subscription-manager repos --enable=rhel-7-server-rpms
echo subscription-manager repos --enable=rhel-7-server-extras-rpms
echo subscription-manager repos --enable=rhel-7-server-optional-rpms

echo msg running yum repolist. Check if this is ok, then press enter to continue, otherwise Ctrl + C to stop and fix
echo yum repolist

msg Installing docker and a registry, kubernetes, and etcd

yum -y install kubernetes docker etcd docker-selinux docker-distribution

msg Diff of etcd/etcd.conf to be copied over
newip=$(ip addr list eth0 | grep 'inet ' | cut -d ' ' -f 6 | cut -d / -f1)
sed -i -e "s/XXIPADDRESSXX/${newip}/g" etcd/*
echo diff etcd/etcd.conf /etc/etcd/etcd.conf
diff etcd/etcd.conf /etc/etcd/etcd.conf

msg Diff of etc/kubernetes config, kubelet, and apiserver files to be copied over
sed -i -e "s/XXIPADDRESSXX/${newip}/g" kubernetes/*
echo diff kubernetes/config /etc/kubernetes/config
diff kubernetes/config /etc/kubernetes/config
echo diff kubernetes/kubelet /etc/kubernetes/kubelet
diff kubernetes/kubelet /etc/kubernetes/kubelet
echo diff kubernetes/apiserver /etc/kubernetes/apiserver
diff kubernetes/apiserver /etc/kubernetes/apiserver

msg Check if the IP addresses correct for your setup. \
Ctrl + C now to end, or press enter to continue
read answer

rsync -avz etcd/ /etc/etcd/
rsync -avz kubernetes/ /etc/kubernetes/

msg Enabling and starting services
./start-kubernetes.sh

msg Try 'kubectl get pods' or 'kubectl -s ${newip} get pods'

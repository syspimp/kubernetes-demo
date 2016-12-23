#!/bin/bash

function msg {
  local RCol='\e[0m'
  local Red='\e[0;31m'
  echo -e "\n${Red}** $*${RCol}"
  sleep 3
}

msg Disabling firewalld
systemctl disable firewalld
systemctl stop firewalld

msg Subscribing to rhn (optional, just echoing commands)
echo subscription-manager register --serverurl=https://subscription.rhn.redhat.com --auto-attach
echo subscription-manager attach
echo subscription-manager repos --disable=*
echo subscription-manager repos --enable=rhel-7-server-rpms
echo subscription-manager repos --enable=rhel-7-server-extras-rpms
echo subscription-manager repos --enable=rhel-7-server-optional-rpms

msg running yum repolist. Check if this is ok, then press enter to continue, otherwise Ctrl + C to stop and fix
yum repolist

msg Installing docker, kubernetes, and etcd

yum -y install kubernetes docker etcd docker-selinux

msg Diff of etcd/etcd.conf to be copied over
diff etcd/etcd.conf /etc/etcd/etcd.conf

msg Diff of etc/kubernetes config, kubelet, and apiserver files to be copied over
echo diff kubernetes/config /etc/kubernetes/config
diff kubernetes/config /etc/kubernetes/config
echo diff kubernetes/kubelet /etc/kubernetes/kubelet
diff kubernetes/kubelet /etc/kubernetes/kubelet
echo diff kubernetes/apiserver /etc/kubernetes/apiserver
diff kubernetes/apiserver /etc/kubernetes/apiserver

msg Change the IP addresses to match your setup.
msg Ctrl + C now to end, or press enter to continue
read answer

rsync -avz etcd/ /etc/etcd/
rsync -avz kubernetes/ /etc/kubernetes/

msg Enabling and starting services
./start-kubernetes.sh

msg Try 'kubectl get pods' or 'kubectl -s 10.55.2.251 get pods'

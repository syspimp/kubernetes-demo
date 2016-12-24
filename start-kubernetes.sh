for SERVICES in docker docker-distribution etcd kube-apiserver kube-controller-manager kubelet kube-proxy.service kube-scheduler.service
do
  systemctl restart $SERVICES;     systemctl enable $SERVICES;     systemctl is-active $SERVICES; systemctl status $SERVICES
done

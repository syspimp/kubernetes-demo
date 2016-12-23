for SERVICES in docker docker-distribution etcd kube-proxy kubelet; do     systemctl restart $SERVICES;     systemctl enable $SERVICES;     systemctl is-active $SERVICES; done
for SERVICES in docker docker-distribution kube-proxy.service kubelet.service; do     systemctl restart $SERVICES;     systemctl enable $SERVICES;     systemctl status $SERVICES; done

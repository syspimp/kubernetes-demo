#!/bin/bash
##
## readme for kubernetes demo
##1. register system
##2. clean docker cache
##3. run build container scripts

function msg {
	echo -e "\n** $*"
	sleep 3
}

msg pulling down the latest rhel7

docker pull rhel7:latest

msg  cloning the demo Docker source code 
#git clone http://github.com/syspimp/kubernetes-demo.git
#cd kubernetes-demo

rm -f mongobuild.log
msg  building the mongo db container version 1
docker build -t rhel7mongodb mydbcontainer | tee mongobuild.log
#docker build --no-cache -t rhel7mongodb mydbcontainer | tee mongobuild.log
IMAGE=$(grep 'Successfully built' mongobuild.log | awk '{print $3}')
[ -z "$IMAGE" ] && ( echo "failed to build." ; read answer -p "Ctrl + C and kill yourself")

msg  tag and push to the local registry
docker tag $IMAGE localhost:5000/rhel7mongodb
docker push localhost:5000/rhel7mongodb

IMAGE=''

rm -f webbuild.log
msg  building the web container version 1
docker build -t rhel7webapp mywebcontainer | tee webbuild.log
#docker build --no-cache -t rhel7webapp mywebcontainer | tee webbuild.log
IMAGE=$(grep 'Successfully built' webbuild.log | awk '{print $3}')
[ -z "$IMAGE" ] && ( echo "failed to build." ; read answer -p "Ctrl + C and kill yourself")

msg  tag and push to the local registry
docker tag $IMAGE localhost:5000/rhel7webapp
docker push localhost:5000/rhel7webapp

msg  creating the kubernetes pods and services
kubectl create -f mongodb-service.yaml --validate=false
kubectl create -f mongodb-rc.yaml --validate=false

msg  waiting for containers to start
msg 

# Get the IP of the database service and set the environment file
# We only include the environment file when running Docker from the command line
# ie Docker run -p 80:80 -e environment webwithdb 
# But with kubernetes we update the yaml file with the correct IP for the variable
#
#DB_IP=$(kubectl describe service mongodb-service | grep IP: | awk '{print $2}')
#echo "ENV MONGODB_SERVICE_SERVICE_IP $DB_IP" > environment
#sed -i -e "s/      value:.*/      value: $DB_IP/" webserver-service.yaml

kubectl create -f webserver-service.yaml --validate=false
kubectl create -f webserver-rc.yaml --validate=false

msg lets get the public ip of our host
IP=$(nmcli connection show eth0 |grep IP4.ADDRESS | awk '{print $2}' )
IP=${IP%%/24}
msg local ip is $IP

msg now lets get the public port
PORT=$(kubectl describe svc webserver| grep '^Port:' | awk '{print $3}' )
PORT=${PORT%%/TCP}
msg node port is $PORT

msg access web app on http://${IP}:${PORT}
curl -s http://${IP}:${PORT}/

msg list the Docker images
echo docker images

msg list running Docker containers
docker ps

msg list kubernetes running pods
kubectl get pods

msg list kubernetes running services
kubectl get svc

msg scale the webserver up to 2 pods
kubectl scale --replicas=2 -f webserver-rc.yaml 

msg rolling update the webservers from one version to next
kubectl rolling-update webserver-controller --image localhost:5000/rhel7webapp:v2 &
sleep 10
kubectl get pods
sleep 5

msg oops we didnt make it yet, roll back
kubectl rolling-update webserver-controller --rollback

msg update the webserver code, tag and push to Docker repo
rm -f webv2build.log
msg we change the index file to say the server is jogging
sed -i -e 's/is running/is jogging/g' mywebcontainer/Dockerfile
docker build -t rhel7webapp:v2 mywebcontainer | tee webv2build.log
IMAGE=''
IMAGE=$(grep 'Successfully built' webv2build.log | awk '{print $3}')
[ -z "$IMAGE" ] && ( echo "failed to build." ; read answer -p "Ctrl + C and kill yourself")

msg  tag and push to the local registry
docker tag $IMAGE localhost:5000/rhel7webapp:v2
docker push localhost:5000/rhel7webapp:v2

kubectl rolling-update webserver-controller --image localhost:5000/rhel7webapp:v2
kubectl get pods

exit


docker logs ef20
docker exec -i -t ef20 /bin/bash

kubectl describe svc webserver

printenv
kubectl exec webserver -- printenv
kubectl get pods
kubectl exec webserver-controller-a4cgz -- printenv
kubectl exec webserver-controller-a4cgz -- printenv | grep SERVICE
curl 172.17.0.5
curl 172.17.0.5/cgi-bin/action
vi mywebcontainer/action
kubectl exec webserver-controller-a4cgz -- printenv | grep SERVICE
kubectl exec webserver-controller-a4cgz -- /bin/bash
kubectl exec webserver-controller-a4cgz -- ls /
docker ps
docker exec -i -t 344d47058537 /bin/bash
curl 172.17.0.5/cgi-bin/action
curl 172.17.0.5/cgi-bin/action|less
docker exec -i -t 344d47058537 /bin/bash
curl 172.17.0.5/cgi-bin/action|less
curl 172.17.0.5/cgi-bin/action
docker exec -i -t 344d47058537 /bin/bash
curl 172.17.0.5/cgi-bin/action
kubectl describe svc webserver

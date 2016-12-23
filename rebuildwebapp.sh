#!/bin/bash
rm -f webbuild.log
docker build -t rhel7webapp mywebcontainer | tee webbuild.log
#docker build --no-cache -t rhel7webapp mywebcontainer | tee webbuild.log
IMAGE=$(grep 'Successfully built' webbuild.log | awk '{print $3}')
[ -z "$IMAGE" ] && ( echo "failed to build." && read -p "Ctrl + C and kill yourself" answer)
docker tag $IMAGE localhost:5000/rhel7webapp
docker push localhost:5000/rhel7webapp

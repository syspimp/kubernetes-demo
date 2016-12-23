#!/bin/bash
kubectl delete rc webserver-controller
kubectl delete rc mongodb-controller
kubectl delete service webserver-service
kubectl delete service mongodb-service

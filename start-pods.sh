#!/bin/bash
kubectl create -f mongodb-service.yaml --validate=false
kubectl create -f mongodb-rc.yaml --validate=false
kubectl create -f webserver-service.yaml --validate=false
kubectl create -f webserver-rc.yaml --validate=false



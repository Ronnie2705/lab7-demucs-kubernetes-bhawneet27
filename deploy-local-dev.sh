#!/bin/sh
#
# You can use this script to launch Redis and minio on Kubernetes
# and forward their connections to your local computer. That means
# you can then work on your worker-server.py and rest-server.py
# on your local computer rather than pushing to Kubernetes with each change.
#
# To kill the port-forward processes us e.g. "ps augxww | grep port-forward"
# to identify the processes ids
#
kubectl create namespace waveseparate
kubectl config set-context --current --namespace=waveseparate

kubectl -n waveseparate apply -f redis/redis-deployment.yaml
kubectl -n waveseparate apply -f redis/redis-service.yaml

kubectl -n waveseparate apply -f rest/rest-deployment.yaml
kubectl -n waveseparate apply -f rest/rest-service.yaml
kubectl -n waveseparate apply -f rest/rest-ingress.yaml

kubectl -n waveseparate apply -f logs/logs-deployment.yaml

kubectl -n waveseparate apply -f worker/worker-deployment.yaml

kubectl -n waveseparate apply -f minio/minio-external-service.yaml


kubectl port-forward --address 0.0.0.0 service/redis 6379:6379 &

sleep 10
# If you're using minio from the kubernetes tutorial this will forward those
kubectl port-forward -n minio-ns --address 0.0.0.0 service/minio-proj 9000:9000 &
kubectl port-forward -n minio-ns --address 0.0.0.0 service/minio-proj 9001:9001 &
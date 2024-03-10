#!/bin/sh
kubectl apply -f ./kubernetes/namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
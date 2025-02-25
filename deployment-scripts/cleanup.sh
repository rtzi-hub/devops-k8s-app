#!/bin/bash

echo "🗑️ Uninstalling Helm Chart..."
helm uninstall devops-app || true

echo "🗑️ Deleting all Kubernetes resources..."
kubectl delete deployment,svc,pvc,secret,configmap --all

echo "🛑 Stopping Minikube..."
minikube stop

echo "✅ Cleanup complete."

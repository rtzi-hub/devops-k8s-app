#!/bin/bash

# Enable error handling
set -e

echo "🚀 Starting Minikube..."
minikube start

echo "🐳 Building Docker Image..."
docker build -t devops-assignment:latest ./docker

echo "📦 Loading Image into Minikube..."
minikube image load devops-assignment:latest

echo "🔧 Deleting Existing Deployments (if any)..."
helm uninstall devops-app || true
kubectl delete deployment,svc,pvc,secret,configmap -l app=devops-app || true
kubectl delete deployment mongodb || true
kubectl delete svc mongodb || true

echo "📦 Installing Helm Chart..."
helm install devops-app ./helm-chart

echo "⏳ Waiting for Pods to Start..."
sleep 30
kubectl get pods

echo "🔗 Getting Service URL..."
minikube service devops-app --url

#!/bin/bash
set -e

# Start Minikube
minikube start

# Use Minikube's Docker environment
eval $(minikube -p minikube docker-env)

# Build the Docker image inside Minikube
docker build -t devops-assignment:1.0 -f docker/Dockerfile .

# Install the Helm chart
helm install devops-app ./helm-chart

# Wait until at least one pod exists
echo "Waiting for pods to be created..."
while [[ $(kubectl get pods -l app=devops-assignment --no-headers 2>/dev/null | wc -l) -eq 0 ]]; do
  sleep 2
  echo "Still waiting for pods..."
done

# Now, wait for them to be fully ready
echo "Pods detected. Waiting for them to be ready..."
kubectl wait --for=condition=Ready pod -l app=devops-assignment --timeout=90s

# Get services and pods
kubectl get pods
kubectl get svc

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)

# Test application endpoints
curl http://$MINIKUBE_IP:32222
curl http://$MINIKUBE_IP:32222/assignment
curl http://$MINIKUBE_IP:32222/health

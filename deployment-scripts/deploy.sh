#!/bin/bash
set -e

echo "🚀 Checking for required dependencies..."

# Ensure npm is installed
if ! command -v npm &> /dev/null; then
    echo "⚠️ npm is not installed! Installing..."
    sudo apt update && sudo apt install -y nodejs npm
fi

# Ensure Minikube is installed
if ! command -v minikube &> /dev/null; then
    echo "⚠️ Minikube is not installed! Please install it first."
    exit 1
fi

# Ensure Helm is installed
if ! command -v helm &> /dev/null; then
    echo "⚠️ Helm is not installed! Please install it first."
    exit 1
fi

echo "🚀 Starting Minikube..."
minikube start --driver=docker

echo "🐳 Configuring Docker to use Minikube's environment..."
eval $(minikube -p minikube docker-env)

echo "📦 Ensuring package-lock.json exists..."
cd app/
if [ ! -f package-lock.json ]; then
    echo "🔄 Generating package-lock.json..."
    npm install --package-lock-only
fi
cd ..

echo "🐳 Building Docker Image inside Minikube..."
docker build -t devops-assignment:latest -f docker/Dockerfile .

echo "📦 Verifying that the image exists in Minikube..."
if ! minikube image list | grep -q "devops-assignment:latest"; then
    echo "❌ Image was not found in Minikube! Loading manually..."
    minikube image load devops-assignment:latest
else
    echo "✅ Image successfully built inside Minikube."
fi

echo "🔧 Deploying Application using Helm..."
helm upgrade --install devops-app ./helm-chart --set image.pullPolicy=Never

echo "⏳ Waiting for Pods to be ready..."
kubectl wait --for=condition=Ready pod -l app=devops-app --timeout=90s || {
    echo "❌ Pods did not start in time. Debugging logs..."
    kubectl get pods
    kubectl describe pods -l app=devops-app
    exit 1
}

echo "🔗 Getting Service URL..."
SERVICE_URL=$(minikube service devops-app --url)
echo "🌍 Access your application at: $SERVICE_URL"

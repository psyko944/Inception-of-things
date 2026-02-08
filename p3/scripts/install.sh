#!/bin/bash

if ! command -v docker &> /dev/null; then
    echo "Docker not installed. Starting installation..."
	curl -fsSL https://get.docker.com -o get-docker.sh
	sudo sh get-docker.sh
	sudo usermod -aG docker $USER
	echo "Docker installed successfully."
else
	echo "Docker is already installed."
fi

if command -v k3d &> /dev/null; then
	echo "✅ k3d already installed. Version : $(k3d --version | head -n 1)"
else
	echo "Installing k3d"
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

CLUSTER_NAME="iot-cluster"

if k3d cluster list | grep -q "$CLUSTER_NAME";then
	echo "✅ cluster $CLUSTER_NAME already exist."
else
	echo "creating cluster: $CLUSTER_NAME"
	k3d  cluster create $CLUSTER_NAME \
		-p "8888:80@loadbalancer" \
		-p "9999:80@loadbalancer" \
		--agents 2
fi
if kubectl get ns dev >/dev/null 2>&1; then
    echo "Namespace 'dev' is ready."
else
    echo "🏗️  Creating 'dev' namespace for the application..."
    kubectl create namespace dev
fi
if kubectl get ns argocd >/dev/null 2>&1; then
    echo "Namespace 'argocd' is ready."
else
    echo "🏗️  Creating 'argocd' namespace for the application..."
    kubectl create namespace argocd
fi
if kubectl diff -f ../confs/application.yaml > /dev/null 2>&1; then
    echo "✅ Application is already up-to-date. Nothing to do."
else
    echo "🔄 Changes detected! Applying configuration..."
    kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl apply -f ../confs/application.yaml
fi

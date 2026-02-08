#!/bin/bash

SERVER_IP=$1
apt-get update -y
echo "Updating package and installing some tools"
apt-get install -y \
  curl \
  vim \
  net-tools \
  wget \
  git

echo "Provisioning server with IP: $SERVER_IP"
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $SERVER_IP --bind-address=$SERVER_IP --advertise-address=$SERVER_IP"
curl -sfL https://get.k3s.io |  sh -

echo "Waiting for k3s node to be Ready..."
until kubectl get node | grep -q "Ready"; do
  sleep 2
done
echo "K3s server installation ."
mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chmod 600 ~/.kube/config
cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/
echo "check k3s correctly installed"
kubectl get node
echo "Vagrant Provisioned Server - IP: $SERVER_IP" > /etc/motd
echo "alias k='kubectl'" >> /etc/profile.d/aliases.sh

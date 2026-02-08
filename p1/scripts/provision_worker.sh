#!/bin/bash
WORKER_IP=$1
SERVER_IP=$2

apt-get update -y
echo "Updating package and installing some tools"
apt-get install -y curl vim net-tools wget git
echo "Waiting for K3s node token from Server: $SERVER_IP..."
while [ ! -f /vagrant/scripts/node-token ]; do
  sleep 5
done

export TOKEN_FILE="/vagrant/scripts/node-token"
echo "[INFO] Token file found. Joining cluster..."
export INSTALL_K3S_EXEC="agent --server https://$SERVER_IP:6443 --token-file $TOKEN_FILE --node-ip=$WORKER_IP --node-name=$(hostname)"

echo "[INFO] ARGUMENT PASSED TO INSTALL_K3S_EXEC: $INSTALL_K3S_EXEC"

curl -sfL https://get.k3s.io | sh -
echo "K3s Agent installation finished. Worker joining cluster."
echo "alias k='kubectl'" >> /etc/profile.d/aliases.sh

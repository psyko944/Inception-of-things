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
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
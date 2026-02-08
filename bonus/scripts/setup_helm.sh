curl -fsSl -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
bash get_helm.sh
if helm version > /dev/null 2>&1; then
    echo "✅ Helm successfully installed"
else
    echo "❌ Failed to installed Helm"
	exit 1
fi
rm get_helm.sh

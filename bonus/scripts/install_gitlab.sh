kubectl create namespace gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab -n gitlab \
  --set global.hosts.domain=lvh.me \
  --set global.hosts.gitlab.hostname=gitlab.lvh.me:9999 \
  --set global.webservice.externalPort=9999 \
  --set global.hosts.https=false \
  --set global.hosts.externalPort=9999 \
  --set global.ingress.enabled=true \
  --set global.ingress.class=traefik \
  --set global.ingress.configureCertmanager=false \
  --set global.ingress.tls.enabled=false \
  --set gitlab.webservice.ingress.tls.enabled=false \
  --set nginx-ingress.enabled=false \
  --set prometheus.install=false \
  --set grafana.install=false \
  --set gitlab-runner.install=false \
  --set gitlab.kas.install=false \
  --set registry.enabled=false \
  --set gitlab.gitlab-shell.service.type=NodePort \
  --set gitlab.webservice.minReplicas=1 \
  --set gitlab.webservice.maxReplicas=1 \
  --set gitlab.sidekiq.minReplicas=1
kubectl wait --for=condition=complete job -l release=gitlab,app=migrations -n gitlab --timeout=600s
kubectl wait --for=condition=Available deployment -l release=gitlab,app=webservice -n gitlab --timeout=300s
echo -n "PASSWORD: "
kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}' | base64 -d; echo

#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/k3s-bootstrap.log) 2>&1

REGION="${region}"
WORKSPACE="${workspace}"

echo "[1/5] Instalando dependências..."
dnf install -y jq aws-cli curl

echo "[2/5] Instalando K3s server..."
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --tls-san $PUBLIC_IP \
  --disable traefik \
  --write-kubeconfig-mode 644" sh -

# Aguarda API server subir
echo "[3/5] Aguardando K3s ficar pronto..."
until kubectl get nodes --kubeconfig /etc/rancher/k3s/k3s.yaml &>/dev/null; do
  sleep 5
done
echo "K3s pronto."

echo "[4/5] Publicando credenciais no SSM..."
K3S_TOKEN=$(cat /var/lib/rancher/k3s/server/node-token)
aws ssm put-parameter \
  --name "/$WORKSPACE/k3s/token" \
  --value "$K3S_TOKEN" \
  --type "SecureString" \
  --overwrite \
  --region "$REGION"

KUBECONFIG_CONTENT=$(sed "s/127.0.0.1/$PUBLIC_IP/g" /etc/rancher/k3s/k3s.yaml)
aws ssm put-parameter \
  --name "/$WORKSPACE/k3s/kubeconfig" \
  --value "$KUBECONFIG_CONTENT" \
  --type "SecureString" \
  --overwrite \
  --region "$REGION"

echo "[5/5] Criando namespace padrão..."
kubectl create namespace cut-url --kubeconfig /etc/rancher/k3s/k3s.yaml || true

echo "Bootstrap do K3s master concluído!"

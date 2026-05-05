#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/k3s-worker-bootstrap.log) 2>&1

REGION="${region}"
WORKSPACE="${workspace}"
MASTER_IP="${master_private_ip}"

echo "[1/3] Instalando dependências..."
dnf install -y jq aws-cli curl

echo "[2/3] Aguardando token K3s no SSM..."
until aws ssm get-parameter \
  --name "/$WORKSPACE/k3s/token" \
  --with-decryption \
  --region "$REGION" &>/dev/null; do
  echo "Token ainda não disponível, aguardando 15s..."
  sleep 15
done

K3S_TOKEN=$(aws ssm get-parameter \
  --name "/$WORKSPACE/k3s/token" \
  --with-decryption \
  --region "$REGION" \
  --query "Parameter.Value" \
  --output text)

echo "[3/3] Ingressando no cluster K3s..."
curl -sfL https://get.k3s.io | \
  K3S_URL="https://$MASTER_IP:6443" \
  K3S_TOKEN="$K3S_TOKEN" \
  sh -

echo "Worker K3s ingressou no cluster com sucesso!"

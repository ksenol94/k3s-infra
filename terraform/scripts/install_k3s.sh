#!/bin/bash
set -e

ROLE=$1

if [ -z "$ROLE" ]; then
  echo "[ERROR] Node role belirtilmedi (master veya worker)"
  exit 1
fi

if [ "$ROLE" == "master" ]; then
  echo "[INFO] K3s master kurulumu yapiliyor..."
  curl -sfL https://get.k3s.io | sh -
  mkdir -p ~/.kube
  sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
  sudo chown $USER:$USER ~/.kube/config
  echo "[INFO] K3s master kurulumu tamamlandi"

elif [ "$ROLE" == "worker" ]; then
  echo "[INFO] Worker node kurulumu başlatiliyor..."
  echo "[WARN] Worker kurulumu için MASTER_IP ve K3S_TOKEN terraform veya manuel ile sağlanmali."
else
  echo "[ERROR] Bilinmeyen role: $ROLE"
  exit 1
fi

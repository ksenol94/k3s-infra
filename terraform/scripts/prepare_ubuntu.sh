#!/bin/bash
set -e

echo "[INFO] Ubuntu server hazırlığı başlatılıyor..."

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k3s.conf
overlay
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

echo "[INFO] Ubuntu hazirligi tamamlandi"

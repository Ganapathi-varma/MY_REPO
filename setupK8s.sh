#!/bin/bash
set -e

echo "📦 Downloading kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "✅ kubectl installed"
kubectl version --client

echo "📦 Downloading kops..."
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

echo "✅ kops installed"
kops version

echo "🌐 Setting KOPS_STATE_STORE..."
export KOPS_STATE_STORE=s3://ganapathivarma.2026.gv

echo "🚀 Creating Kubernetes cluster using kops..."
kops create cluster \
  --name ganapathivarma.k8s.local \
  --zones ap-south-1b,ap-south-1a \
  --master-size c7i-flex.large \
  --master-count 1 \
  --master-volume-size 30 \
  --node-size t3.micro \
  --node-count 2 \
  --node-volume-size 20 \
  --image ami-02b8269d5e85954ef

echo "🎉 Cluster configuration created successfully!"
echo "👉 Run: kops update cluster --name ganapathivarma.k8s.local --yes"

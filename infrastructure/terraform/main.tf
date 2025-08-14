terraform {
  required_version = ">= 1.5.0"
}

resource "null_resource" "kind_cluster" {
  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
set -e
cat > kind.yaml <<CFG
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:5001"]
    endpoint = ["http://kind-registry:5000"]
nodes:
- role: control-plane
- role: worker
CFG

# Jalankan registry untuk kind
docker rm -f kind-registry >/dev/null 2>&1 || true
docker run -d -p 5001:5000 --name kind-registry registry:2

# Buat cluster kind
kind delete cluster --name dev >/dev/null 2>&1 || true
kind create cluster --name dev --config kind.yaml

# Sambungkan registry ke jaringan kind
docker network connect kind kind-registry || true

# Label node supaya ingress-nginx bisa jalan
CONTROL_PLANE_NODE=$(kubectl get nodes -o name | grep control-plane | sed 's|node/||')
kubectl label node $CONTROL_PLANE_NODE ingress-ready=true

# Tunggu semua node Ready
kubectl wait --for=condition=Ready nodes --all --timeout=120s

# Ingress NGINX
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/kind/deploy.yaml
EOT
  }
}

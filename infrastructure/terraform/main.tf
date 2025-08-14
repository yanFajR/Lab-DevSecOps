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

docker rm -f kind-registry >/dev/null 2>&1 || true
docker run -d -p 5001:5000 --name kind-registry registry:2

kind delete cluster --name dev >/dev/null 2>&1 || true
kind create cluster --name dev --config kind.yaml

docker network connect kind kind-registry || true

# Ingress NGINX
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
EOT
  }
}

APP?=api
TAG?=dev
IMAGE?=localhost:5001/$(APP):$(TAG)
NS_APPS?=apps
NS_PLATFORM?=platform

.PHONY: bootstrap cluster apm secrets build scan push deploy logs demo clean nuke

bootstrap:
	@ansible-playbook infrastructure/ansible/bootstrap.yml

cluster:
	@cd infrastructure/terraform && terraform init && terraform apply -auto-approve
	@kubectl create namespace $(NS_PLATFORM) --dry-run=client -o yaml | kubectl apply -f -
	@kubectl create namespace $(NS_APPS) --dry-run=client -o yaml | kubectl apply -f -
	@kubectl -n $(NS_PLATFORM) wait --for=condition=available deploy/ingress-nginx-controller --timeout=180s || true

apm:
	@cd monitoring && docker compose up -d

secrets:
	@bash scripts/sync_infisical_k8s.sh

build:
	@cd apps/$(APP) && docker build -t $(IMAGE) .

scan:
	@trivy image --severity HIGH,CRITICAL --exit-code 1 $(IMAGE)

push:
	@docker push $(IMAGE)

deploy:
	@kubectl apply -f infrastructure/kubernetes/postgres.yaml
	@kubectl apply -f infrastructure/kubernetes/pgbouncer.yaml
	@kubectl apply -f infrastructure/kubernetes/api.yaml
	@kubectl apply -f infrastructure/kubernetes/ingress.yaml
	@kubectl -n $(NS_APPS) rollout status deploy/api --timeout=120s

logs:
	@kubectl -n $(NS_APPS) logs -l app=$(APP) -f

demo:
	@bash scripts/demo.sh

clean:
	@cd monitoring && docker compose down || true
	@kubectl delete -f infrastructure/kubernetes/api.yaml --ignore-not-found=true || true
	@kubectl delete -f infrastructure/kubernetes/pgbouncer.yaml --ignore-not-found=true || true
	@kubectl delete -f infrastructure/kubernetes/postgres.yaml --ignore-not-found=true || true

nuke:
	@cd infrastructure/terraform && terraform destroy -auto-approve || true
	@docker rm -f kind-registry || true

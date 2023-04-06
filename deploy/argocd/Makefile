APP_NAME ?= argocd
ARGO_NAMESPACE ?= argocd
CLUSTER_NAME ?= minikube

ARGO_ADMIN_PASSWORD ?= default-password

ARGOCD_PORT ?= 8080
ARGOCD_URL ?= localhost:$(ARGOCD_PORT)

deps:
	@helm version &> /dev/null || (echo "ERROR: Please install helm..." && false)
	@helm repo add argo https://argoproj.github.io/argo-helm
	@helm repo update
	@touch $@

deploy: deps ## deploy helm chart
	helm install $(APP_NAME) argo/argo-cd --namespace=$(ARGO_NAMESPACE) --create-namespace
	@sleep 10
	@kubectl port-forward service/argocd-server -n argocd $(ARGOCD_PORT):443 &
	@touch $@

undeploy: deps ## deletes project using k8s
	helm uninstall $(APP_NAME) -n $(ARGO_NAMESPACE) || true
	rm -rf deploy deps argo-setup

rollback: deps ## rollback to the previuos deployment version
	helm rollback $(APP_NAME) -n $(ARGO_NAMESPACE)
	
status-deploy: deps ## show status of k8s deployment
	@echo "============== K8S DEPLOYMENTS ==================="
	helm status $(APP_NAME) -n $(ARGO_NAMESPACE)
	kubectl get all -l app=$(APP_NAME) -n $(ARGO_NAMESPACE)

smoke-test:
	curl http://$(ARGOCD_URL)

argo-setup: deploy
	@argocd login $(ARGOCD_URL) --insecure --username admin --password $(shell kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
	@argocd account update-password --account admin --current-password $(shell kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d) --new-password $(ARGO_ADMIN_PASSWORD)
	argocd cluster add $(CLUSTER_NAME) --yes
	@touch $@

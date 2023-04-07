APP_NAME=k8s-gitops-deployment-fastapi
APP_NAMESPACE=k8s-gitops

GIT_APP_URL ?= https://github.com/DamZiobro/k8s-gitops-deployment-template.git
GIT_APP_PATH ?= deploy/services/k8s-gitops-deployment-fastapi 

################################################################################
# HELM
################################################################################

helm-deps:
	@helm version &> /dev/null || (echo "ERROR: Please install helm..." && false)
	@kubectl version &> /dev/null || (echo "ERROR: Please install kubectl..." && false)
	@touch $@

helm-deploy: helm-deps ## deploy helm chart
	helm upgrade --atomic --install $(APP_NAME) --namespace=$(APP_NAMESPACE) --create-namespace $(APP_NAME)

helm-undeploy: helm-deps ## deletes project using k8s
	helm uninstall $(APP_NAME) -n $(APP_NAMESPACE) || true

helm-rollback: helm-deps ## rollback to the previuos deployment version
	helm rollback $(APP_NAME) -n $(APP_NAMESPACE)
	
helm-status-deploy: helm-deps ## show status of k8s deployment
	@echo "============== K8S DEPLOYMENTS ==================="
	helm status $(APP_NAME) -n $(APP_NAMESPACE)
	kubectl get all -l app=$(APP_NAME) -n $(APP_NAMESPACE)

################################################################################
# ARGOCD
################################################################################

argo-deps:
	@argocd version &> /dev/null || (echo "ERROR: Please install argocd CLI..." && false)
	@kubectl version &> /dev/null || (echo "ERROR: Please install kubectl..." && false)
	@touch $@

argo-setup: argo-deps
	argocd app create $(APP_NAME) --repo $(GIT_APP_URL) --path $(GIT_APP_PATH) --dest-server https://kubernetes.default.svc --dest-namespace $(APP_NAMESPACE)
	argocd app sync $(APP_NAME)
	argocd app set $(APP_NAME) --sync-policy automated
	@touch $@
	

argo-deploy: argo-setup
	argocd app sync $(APP_NAME) 

argo-undeploy: argo-deps
	argocd app delete $(APP_NAME) --yes

argo-rollback: argo-deps
	argocd app rollback $(APP_NAME)

argo-status-deploy: helm-deps ## show status of k8s deployment
	argocd app get $(APP_NAME)

smoke-test:
	curl -H "Host: k8s-gitops-deployment-fastapi.info" http://$(shell minikube ip)/

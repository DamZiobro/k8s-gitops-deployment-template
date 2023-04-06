APP_NAME=k8s-gitops-deployment-fastapi
APP_NAMESPACE=k8s-gitops

GIT_APP_URL ?= https://github.com/DamZiobro/k8s-gitops-deployment-template.git
GIT_APP_PATH ?= deploy/services/k8s-gitops-deployment-fastapi 

deps:
	@helm version &> /dev/null || (echo "ERROR: Please install helm..." && false)
	@kubectl version &> /dev/null || (echo "ERROR: Please install kubectl..." && false)
	@argocd version &> /dev/null || (echo "ERROR: Please install argocd CLI..." && false)
	@touch $@

deploy: deps ## deploy helm chart
	helm upgrade --atomic --install $(APP_NAME) --namespace=$(APP_NAMESPACE) --create-namespace $(APP_NAME)

argo-deploy: deps
	argocd app create $(APP_NAME) --repo $(GIT_APP_URL) --path $(GIT_APP_PATH) --dest-server https://kubernetes.default.svc --dest-namespace $(APP_NAMESPACE)
	argocd app sync $(APP_NAME)

undeploy: deps ## deletes project using k8s
	helm uninstall $(APP_NAME) -n $(APP_NAMESPACE) || true

rollback: deps ## rollback to the previuos deployment version
	helm rollback $(APP_NAME) -n $(APP_NAMESPACE)
	
status-deploy: deps ## show status of k8s deployment
	@echo "============== K8S DEPLOYMENTS ==================="
	helm status $(APP_NAME) -n $(APP_NAMESPACE)
	kubectl get all -l app=$(APP_NAME) -n $(APP_NAMESPACE)

smoke-test:
	curl -H "Host: k8s-gitops-deployment-fastapi.info" http://$(shell minikube ip)/

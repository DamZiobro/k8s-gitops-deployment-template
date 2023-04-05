APP_NAME=k8s-gitops-deployment-fastapi
NAMESPACE=k8s-gitops

deps:
	@helm version &> /dev/null || (echo "ERROR: Please install helm..." && false)
	@kubectl version &> /dev/null || (echo "ERROR: Please install kubectl..." && false)

deploy: deps ## deploy helm chart
	helm upgrade --atomic --install $(APP_NAME) --namespace=$(NAMESPACE) --create-namespace $(APP_NAME)

undeploy: deps ## deletes project using k8s
	helm uninstall $(APP_NAME) -n $(NAMESPACE) || true

rollback: deps ## rollback to the previuos deployment version
	helm rollback $(APP_NAME) -n $(NAMESPACE)
	
status-deploy: deps ## show status of k8s deployment
	@echo "============== K8S DEPLOYMENTS ==================="
	helm status $(APP_NAME) -n $(NAMESPACE)
	kubectl get all -l app=$(APP_NAME) -n $(NAMESPACE)

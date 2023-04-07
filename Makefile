CLUSTER_ENV=minikube
CLUSTER_NAME=minikube

deps:
	make -C infrastructure/$(CLUSTER_ENV) deps
	make -C infrastructure/api deps
	make -C deploy/services deps

##############################################################################
# CLUSTER CONFIG
##############################################################################

cluster-up: ## set up k8s cluster
	make -C infrastructure/$(CLUSTER_ENV) cluster-up

argo-setup: ## setup ArgoCD server
	make -C deploy/argocd deploy
	make -C deploy/argocd argo-setup

argo-login:
	make -C deploy/argocd argo-login

dist-clean:
	make -C infrastructure/$(CLUSTER_ENV) cluster-down
	make -C deploy/argocd clean
	make -C deploy/services clean

##############################################################################
# APP DEVELOPMENT COMMANDS
##############################################################################

build: ## build docker image
	make -C services/api build

push: build ## push docker image do docker registry
	make -C services/api push

##############################################################################
# APP CONFIG / COMMANDS
##############################################################################

argo-deploy: ## deploy using ArgoCD using GitOps rules
	make -C deploy/services argo-deploy

argo-undeploy:
	make -C deploy/services argo-undeploy

argo-rollback:
	make -C deploy/services argo-rollback

helm-deploy: ## deploy using helm
	make -C deploy/services helm-deploy

helm-undeploy: ## undeploy using helm
	make -C deploy/services helm-undeploy

helm-rollback:
	make -C deploy/services helm-rollback

smoke-test:
	make -C deploy/services smoke-test

.PHONY: deploy

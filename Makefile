CLUSTER_ENV=minikube
CLUSTER_NAME=minikube

deps:
	make -C infrastructure/$(CLUSTER_ENV) deps
	make -C infrastructure/api deps
	make -C deploy/services deps

cluster-up: ## set up k8s cluster
	make -C infrastructure/$(CLUSTER_ENV) cluster-up

build: ## build docker image
	make -C services/api build

push: build ## push docker image do docker registry
	make -C services/api push

argo-setup: ## setup ArgoCD server
	make -C deploy/argocd deploy
	make -C deploy/argocd argo-setup

argo-deploy: ## deploy using ArgoCD using GitOps rules
	make -C deploy/services argo-deploy

argo-undeploy:
	make -C deploy/argocd undeploy

deploy: ## deploy using helm
	make -C deploy/services deploy

undeploy:
	make -C deploy/services undeploy

smoke-test:
	make -C deploy/services smoke-test

dist-clean:
	make -C infrastructure/$(CLUSTER_ENV) cluster-down

.PHONY: deploy

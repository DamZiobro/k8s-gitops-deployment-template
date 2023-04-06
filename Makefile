CLUSTER_ENV=minikube
CLUSTER_NAME=minikube
APP_NAME=k8s-gitops-deployment

deps:
	make -C infrastructure/$(CLUSTER_ENV) deps
	make -C infrastructure/api deps
	make -C deploy/services deps

cluster-up:
	make -C infrastructure/$(CLUSTER_ENV) cluster-up

build:
	make -C services/api build

push: build
	make -C services/api push

deploy:
	make -C deploy deploy

undeploy: cluster-up push
	make -C deploy/api undeploy

dist-clean:
	make -C infrastructure/$(CLUSTER_ENV) cluster-down

.PHONY: deploy

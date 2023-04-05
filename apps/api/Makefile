APP_NAME=k8s-gitops-deployment

APP_LOCAL_PORT ?= 3000
DOCKER_REG_PORT ?= 5000
DOCKER_REG_IP ?=localhost
DOCKER_REG_URL ?= $(DOCKER_REG_IP):$(DOCKER_REG_PORT)
DOCKER_IMAGE_NAME=k8s-gitops-deployment
IMAGE_VERSION ?= 0.0.1

#=========================================================
# LOCAL DEV docker commands
#=========================================================

deps: ## verifies project-related dependency tools are up and running
	@docker --version &> /dev/null || (echo "ERROR: docker tool is NOT installed on your local machine" && false)

build: deps ## build project-related docker images
	docker build -t $(DOCKER_IMAGE_NAME):$(IMAGE_VERSION) .

run: deps ## runs project-related docker container (build must be performed first)
	docker run -d --name $(APP_NAME) -p $(APP_LOCAL_PORT):80 $(DOCKER_IMAGE_NAME):$(IMAGE_VERSION)
	echo "API is up-and-running on http://localhost:$(APP_LOCAL_PORT)"

stop: ## stops project-related docker containers (without deleting them)
	docker stop -d --name $(APP_NAME)

clean: ## delete project-related docker containers and docker images (does not delete any k8s-based deployed resources)
	docker rm -f $(APP_NAME)
	docker rmi -f $(DOCKER_IMAGE_NAME)

#=========================================================
# LOCAL DEV kubernetes DEV commands
#=========================================================

push: build ## pushes project-related docker images into local docker registry
	docker tag $(DOCKER_IMAGE_NAME):$(IMAGE_VERSION) $(DOCKER_REG_URL)/$(DOCKER_IMAGE_NAME):$(IMAGE_VERSION)
	docker push $(DOCKER_REG_URL)/$(DOCKER_IMAGE_NAME):$(IMAGE_VERSION)

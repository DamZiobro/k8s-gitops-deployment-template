CLUSTER_NAME ?= minikube
NUMBER_OF_NODES ?= 1

deps:
	@minikube version &> /dev/null || ( echo "ERROR: please install minikube" && false )

cluster-up: deps
	# TODO - rework this to terraform
	minikube start --nodes $(NUMBER_OF_NODES) -p $(CLUSTER_NAME)
	minikube addons enable metrics-server -p $(CLUSTER_NAME)
	minikube addons enable registry -p $(CLUSTER_NAME)
	minikube addons enable ingress -p $(CLUSTER_NAME)
	minikube addons enable ingress-dns -p $(CLUSTER_NAME)
	# redirect minikube local registry port 5000 into localhost:5000
	sleep 5 && docker run -d --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip):5000"
	touch $@

cluster-down: deps
	# TODO - rework this to terraform
	minikube delete -p $(CLUSTER_NAME)
	rm -rf cluster-up

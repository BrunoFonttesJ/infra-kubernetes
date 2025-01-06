SHELL := /bin/bash

install-nginx-gateway:
	@printf "\n\n++++++++++++++ STARTING install-nginx-gateway ++++++++++++++++++\n";
	kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml;
	kubectl kustomize "https://github.com/nginxinc/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.4.0" | kubectl apply -f -;
	kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/crds.yaml;
	kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/nodeport/deploy.yaml;
	@printf "\n\n++++++++++++++ DONE WITH install-nginx-gateway ++++++++++++++++++\n";

build-home:
	@printf "\n\n++++++++++++++ STARTING build-home ++++++++++++++++++\n";
	cd src/home; docker build -t home-service:latest .
	@printf "\n\n++++++++++++++ DONE WITH build-home ++++++++++++++++++\n";

build-green-home:
	@printf "\n\n++++++++++++++ STARTING build-home ++++++++++++++++++\n";
	cd src/green-home; docker build -t green-home-service:latest .
	@printf "\n\n++++++++++++++ DONE WITH build-home ++++++++++++++++++\n";

build-checkout:
	@printf "\n\n++++++++++++++ STARTING build-checkout ++++++++++++++++++\n";
	cd src/checkout; docker build -t checkout-service:latest .
	@printf "\n\n++++++++++++++ DONE WITH build-checkout ++++++++++++++++++\n";

deploy-namespaces:
	@printf "\n\n++++++++++++++ STARTING deploy-namespaces ++++++++++++++++++\n";
	kubectl apply -f namespaces.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-namespaces ++++++++++++++++++\n";

deploy-home:
	@printf "\n\n++++++++++++++ STARTING deploy-home ++++++++++++++++++\n";
	cd src/home; kubectl apply -f deployment-config.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-home ++++++++++++++++++\n";

deploy-green-home:
	@printf "\n\n++++++++++++++ STARTING deploy-home ++++++++++++++++++\n";
	cd src/green-home; kubectl apply -f deployment-config.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-home ++++++++++++++++++\n";

deploy-checkout:
	@printf "\n\n++++++++++++++ STARTING deploy-checkout ++++++++++++++++++\n";
	cd src/checkout; kubectl apply -f deployment-config.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-checkout ++++++++++++++++++\n";

deploy-gateway-api:
	@printf "\n\n++++++++++++++ STARTING deploy-gateway-api ++++++++++++++++++\n";
	kubectl apply -f gateway-api-config.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-gateway-api ++++++++++++++++++\n";

build: build-home build-green-home build-checkout
	@printf "\n\n++++++++++++++ STARTING build ++++++++++++++++++\n";
	@printf "\n\n++++++++++++++ DONE WITH build ++++++++++++++++++\n";

deploy: deploy-namespaces deploy-home deploy-green-home deploy-checkout deploy-gateway-api
	@printf "\n\n++++++++++++++ STARTING deploy ++++++++++++++++++\n";
	@printf "\n\n++++++++++++++ DONE WITH deploy ++++++++++++++++++\n";

expose:
	@printf "\n\n++++++++++++++ STARTING expose ++++++++++++++++++\n";
	kubectl port-forward svc/nginx-gateway 8080:80 -n nginx-gateway
	@printf "\n\n++++++++++++++ DONE WITH expose ++++++++++++++++++\n";
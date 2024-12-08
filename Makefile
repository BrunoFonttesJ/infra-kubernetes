SHELL := /bin/bash

build-home:
	@printf "\n\n++++++++++++++ STARTING build-home ++++++++++++++++++\n";
	cd src/home; docker build -t home-service:latest .
	@printf "\n\n++++++++++++++ DONE WITH build-home ++++++++++++++++++\n";

build-canary-home:
	@printf "\n\n++++++++++++++ STARTING build-home ++++++++++++++++++\n";
	cd src/canary-home; docker build -t canary-home-service:latest .
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

deploy-canary-home:
	@printf "\n\n++++++++++++++ STARTING deploy-home ++++++++++++++++++\n";
	cd src/canary-home; kubectl apply -f deployment-config.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-home ++++++++++++++++++\n";

deploy-checkout:
	@printf "\n\n++++++++++++++ STARTING deploy-checkout ++++++++++++++++++\n";
	cd src/checkout; kubectl apply -f deployment-config.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-checkout ++++++++++++++++++\n";

deploy-gateway-api:
	@printf "\n\n++++++++++++++ STARTING deploy-gateway-api ++++++++++++++++++\n";
	kubectl apply -f gateway-api-config.yml
	@printf "\n\n++++++++++++++ DONE WITH deploy-gateway-api ++++++++++++++++++\n";

build: build-home build-canary-home build-checkout
	@printf "\n\n++++++++++++++ STARTING build ++++++++++++++++++\n";
	@printf "\n\n++++++++++++++ DONE WITH build ++++++++++++++++++\n";

deploy: deploy-namespaces deploy-home deploy-canary-home deploy-checkout deploy-gateway-api
	@printf "\n\n++++++++++++++ STARTING deploy ++++++++++++++++++\n";
	@printf "\n\n++++++++++++++ DONE WITH deploy ++++++++++++++++++\n";

expose:
	@printf "\n\n++++++++++++++ STARTING expose ++++++++++++++++++\n";
	kubectl port-forward svc/nginx-gateway 8080:80 -n nginx-gateway
	@printf "\n\n++++++++++++++ DONE WITH expose ++++++++++++++++++\n";
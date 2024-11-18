SHELL := /bin/bash

use-minikube-docker:
	@printf "\n\n++++++++++++++ STARTING use-minikube-docker ++++++++++++++++++\n";
	eval $$(minikube -p minikube docker-env)
	@printf "\n\n++++++++++++++ DONE WITH use-minikube-docker ++++++++++++++++++\n";

build-home:
	@printf "\n\n++++++++++++++ STARTING build-home ++++++++++++++++++\n";
	cd src/home; docker build -t home-service:latest .
	@printf "\n\n++++++++++++++ DONE WITH build-home ++++++++++++++++++\n";

build-checkout:
	@printf "\n\n++++++++++++++ STARTING build-checkout ++++++++++++++++++\n";
	cd src/checkout; docker build -t checkout-service:latest .
	@printf "\n\n++++++++++++++ DONE WITH build-checkout ++++++++++++++++++\n";

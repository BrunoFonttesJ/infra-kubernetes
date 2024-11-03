# infra-kubernetes

This project builds an infrastructure capable of supporting thousands of concurrent requests for an endpoint simulating a highly demmanded GET api.

Concepts explored:
- health check
- load balancing
- ingress


Pre-requirements:
- [Docker](https://docs.docker.com/engine/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)


Building the dockerfile image:

Let's start by building our docker image:
```
docker build -t hello-world:latest .
```

Starting minikube:
```
minikube start --driver=docker
```

Pointing your shell to minikube's docker-daemon:
```
eval $(minikube -p minikube docker-env)
```

Deploying the application:
```
kubectl apply -f deployment-config.yml
```

Exposing the application to the host machine:
```
kubectl port-forward service/nodejs-app-lb  3000:3000
```

You can also launch minikube dashboard to follow your cluster resources:
```
minikube dashboard
```

Executing the load tests:
WIP
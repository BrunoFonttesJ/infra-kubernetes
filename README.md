# infra-kubernetes

This project builds an infrastructure capable of supporting thousands of concurrent requests for an endpoint simulating a highly demmanded GET api.

Concepts explored:
- Liveness probe
- Load balancing
- Auto scaling
- Namespaces
- Gateway API


Pre-requirements:
- [Docker](https://docs.docker.com/engine/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)


#### Start minikube:
```
minikube start --driver=docker
```

## Installing NGINX Gateway

#### Kubernetes Gateway API

The Gateway API Resources from the standard channel must be installed before deploying NGINX Gateway Fabric.
```
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
```


#### API Resources
```
kubectl kustomize "https://github.com/nginxinc/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.4.0" | kubectl apply -f -
```

##### CRDs
```
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/crds.yaml
```

##### Deploy
By default, NGINX Gateway Fabric is installed in the nginx-gateway namespace. You can deploy in another namespace by modifying the manifest files.
In this application we are going to use a service of type NodePort to expose it to the host:
```
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/nodeport/deploy.yaml
```

##### Verify the Deployment
```
kubectl get pods -n nginx-gateway
```
The output should look similar to this:
```
NAME                             READY   STATUS    RESTARTS   AGE
nginx-gateway-5d4f4c7db7-xk2kq   2/2     Running   0          112s
```

## Installing the application

##### Create the development namespace
```
kubectl create -f namespaces.yml
```

#### Build the application image

Point your shell to minikube's docker-daemon, run:
 eval $(minikube -p minikube docker-env)
```

Now, let's start by building our docker image into minikube's docker-deamon:
```
docker build -t hello-world:latest .
```

##### Deploy the application
```
kubectl apply -f deployment-config.yml
```

##### Expose the application to the host machine
As this solution was originally built in mac os and the docker driver has a network limitation on it, we cannot use the pattern <minikube ip>:<nginx svc node port>.

More details on minikube docs: [link](https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-service-with-tunnel)

** consider chaging driver to hyperkit on mac to cover more features
```
kubectl port-forward svc/nginx-gateway 8080:80 -n nginx-gateway
```

You can also launch minikube dashboard to follow your cluster resources:
```
minikube dashboard
```

## Executing the load tests:
WIP
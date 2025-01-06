# infra-kubernetes

This project builds an infrastructure capable of supporting thousands of concurrent requests for an endpoint simulating a highly demmanded GET api.

Concepts explored:

- Liveness probe
- Load balancing
- Auto scaling
  - pods
- Namespaces
- Gateway API
  - Nginx Gateway Fabric
  - Blue-Green release
  - Canary release

Roadmap:

- Gateway API
  - HTTPS TLS setup
- Log agent configuration
- Container registry
- CI configuration
- CD configuration
- Auto scaling
  - Cluster auto scaling - Cloud Provider

Pre-requirements:

- [Docker](https://docs.docker.com/engine/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)

## Start minikube:

```
minikube start --driver=docker
```

## Installing NGINX Gateway

### Kubernetes Gateway API

The Gateway API Resources from the standard channel must be installed before deploying NGINX Gateway Fabric.

```
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
```

### API Resources

```
kubectl kustomize "https://github.com/nginxinc/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v1.4.0" | kubectl apply -f -
```

### CRDs

```
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/crds.yaml
```

### Deploy

By default, NGINX Gateway Fabric is installed in the nginx-gateway namespace. You can deploy in another namespace by modifying the manifest files.
In this application we are going to use a service of type NodePort to expose it to the host:

```
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/nodeport/deploy.yaml
```

### Verify the Deployment

```
kubectl get pods -n nginx-gateway
```

The output should look similar to this:

```
NAME                             READY   STATUS    RESTARTS   AGE
nginx-gateway-5d4f4c7db7-xk2kq   2/2     Running   0          112s
```

## Installing the application

### Build

Point your shell to minikube's docker-daemon by running the following:

```
eval $(minikube -p minikube docker-env)
```

And then, build your services images:

```
make build
```

### Deploy

To deploy the images created in the previous step, execute the following:

```
make deploy
```

## Exposing the application to the host machine

As this solution was originally built in mac os and the docker driver has a network limitation on it, we cannot use the pattern <minikube ip>:<nginx svc node port>.

More details on minikube docs: [link](https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-service-with-tunnel)

\* Consider chaging driver to hyperkit on mac to cover more features.

```
make expose
```

## Monitoring the cluster resources

Launch minikube dashboard to monitor your cluster resources:

```
minikube dashboard
```

## Testing the app endpoints

### Blue-Green release feature

To test the blue-green deployment do the following on your terminal or hit it directly in your browser:

```
curl --location 'http://localhost:8080/site/home'
```

The configuration is set to be routing traffic equally between the blue and the green deployments, so that as you hit this url multiple times, you will see that the response messages will be interleaving between `Welcome to Blue Home service!` and `Welcome to Green Home service!`.

### Multiple Backend services unified under the API Gateway

We have two services deployed under our API Gateway. The home one(GET /site/home), tested in the previous step, and the checkout service, being served by our API Gateway as follows:

```
curl --location 'http://localhost:8080/site/checkout'
```

## Useful commands:

While monitoring your cluster you might find these commands useful:

```shell
kubectl get namespaces
kubectl get {kubernetes object} -n {namespace} # kubernetes object: [svc, pods, httproute, containers]
kubectl get logs {containerId} -n {namespace}
kubectl describe pod {podId} -n {namespace}
kubectl describe httproute {podId} -n {namespace}
kubectl describe deployment {podId} -n {namespace}
```

## Executing the load tests:

WIP

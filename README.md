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

- Helm implementation
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

## Introduction to Kubernetes

If you are already familiar with kubernetes and its basic components,you can skip this section and move on to the next one.

### Concepts:

- **Platform**: Structures that allow multiple products to be built within the same technical framework.
- **Application Workload**: The amount of work that needs to be done in a period of time.
- **State**: A set of declarative configurations that define the application version, memory, cpu and auto-scaling rules among others.
  - **Desired state**: The desired state can be changed when occurs a new deployment or an auto-scaling rule triggering, for example.
  - **Current state**: It is what kubernetes checks constantly to see if there are any differences against the desired state. If so, it will start the necessary tasks to change it towards the desired one.
- **Service discovery**: A process capable of identifing and connecting services within a network without requiring hardcoded ip addresses. This is achievable through dns records.
- **Sidecar containers**: Secondary containers that run along with the main application container, within the same Pod. They are used to extend or enhance the main functionaly of an app by providing additional services or functionalities such as logging, monitoring and security.

### Kubernetes
Kubernetes is a platform for managing containerized workloads. Some of its main responsabilities are as follows:
- Reliability: Keep the infrastructure current state equal to the desired state.
- Scalability: Change the desired state accordingly to pre-defined metrics such as memory usage and cpu usage.
- Load Balancing: Load balance traffic among deployment replicas.
- Facilitates zero-downtime deployments through strategies such as Rolling updates, Canary and Blue-Green.

### Pod
The pod is the smallest deployable unit in kubernetes architecture. It consists of a group of one or more containers with shared storage and network resources.
Usually if it has more than one container it is going to be due the use of a sidecar pattern.

### Service
The service is an abstraction that helps exposing a group of pods over a network so that clients can interact with it.

### Deployment
The deployment is responsible for changing the actual state to the desired state at a controlled rate.
Some of the main configuration that can be done in the deployment are listed as follows:
- target container
- resources(cpu/memory)
- liveness probe endpoint
- desired amount of replicas

Initially, given the desired state described in the deployment(based on the configurations listed above and others) and then, the deployment controller will allocate the required resources and deploy the target application. 
From that point on, if the desired state is updated by a HorizontalPodAutoscaler policy or the actual state changes due to a pod becoming unhealthy, the deployment controller will be changing the actual state to meet the desired one.


### HorizontalPodAutoscaler
TBD

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

Usually in this deployment strategy, 100% of the traffic is sent to the green deployment and the blue one is kept intact, so that, in case of finding any issues on the green version, it is possible to just switch to the blue deployment(stable) with minimal complexity and impact.

In this example, just for proof-of-concept purposes, we have it weighted, simulating a scenario that demands an incremental risk management. This hybrid model is useful for high-traffic and mission-critical systems where an instant cutover may introduce unnaceptable risks. This approach is also similar to a canary release based on weight.

### Canary relase feature(Based on header)

TBD

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

# minikube-poc

Pre-requirements:
- docker
- kubectl
- minikube


Building the dockerfile image:

Let's start by building our docker image:
```
docker build -t hello-world:latest .
```

Starting minikube:
```
minikube start --driver=docker
```

Deploying the application:
```
kubectl apply -f deployment-config.yml
```

Now, let's try to check if the pods were created correctly:
```
kubectl get pods
```
There will be an error like this:
```
NAME                                       READY   STATUS              RESTARTS   AGE
nodejs-hello-deployment-76c5c5554f-kwkm8   0/1     ErrImageNeverPull   0          62s
```
This happens because by default minikube will try to pull the image from its private or a public registry.
The next steps will cover how to enable using local images in minikube.

Using a local image in minikube:

Let's see the steps required to point our terminal's docker-cli to the docker engine inside minikube:
```
$ minikube docker-env
```
The output should be similar to this:

```
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://127.0.0.1:52845"
export DOCKER_CERT_PATH="/Users/brunofontes/.minikube/certs"
export MINIKUBE_ACTIVE_DOCKERD="minikube"

# To point your shell to minikube's docker-daemon, run:
# eval $(minikube -p minikube docker-env)
```

And then, re-apply the deployment config:
```
kubectl apply -f deployment-config.yml 

```
Useful commands to check the infrastructure deployed:
```
kubectl get deployment
kubectl get services
kubectl get pods
```

Exposing the application to the host machine:
```
kubectl port-forward service/nodejs-app-lb  3000:3000
```

Last but not least we can follow the infraestructure changes by the minikube dashboard by executing the following:
```
minikube dashboard
```
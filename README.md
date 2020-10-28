# Docker image containing Consul and Envoy and Service applications


[Docker][docker] image containing [Consul][consul] and [Envoy][envoy] which can also register services and central config when starting.
Can be used for registering services or config, or when you need an Envoy sidecar.

**Warning:** The image is not intended for production use. It is intended to mimic the behavior of a VM with a container and build test environments to test Consul functionalities without the overhead of deploying a full VM.

## Start container

### Provision configuration files
The container expects configuration files to be created and shared with the container in a Docker volume.

* Create volumes

```
docker volume create server_config > /dev/null
docker volume create client_config > /dev/null
docker container create --name volumes -v server_config:/server -v client_config:/client alpine > /dev/null
```

* Copy configuration files 

```
# Server files
docker cp ./server.hcl volumes:/server/server.hcl
```

```
# Client files
docker cp ./agent.hcl volumes:/client/agent.hcl
docker cp ./svc-client.hcl volumes:/client/svc-client.hcl
```

### Consul server

```
 docker run \
  -d \
  -v server_config:/etc/consul.d \
  -p 8500:8500 \
  -p 8600:8600/udp \
  --name=server \
  danielehc/consul-learn-image:${IMAGE_TAG} \
  consul agent -server -ui \
    -node=server-1 \
    -bootstrap-expect=1 \
    -client=0.0.0.0 \
    -config-file=/etc/consul.d/server.hcl
```

Get server IP:

```
SERVER_IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' server`
```

### Consul client

```
docker run \
    -d \
    -v client_config:/etc/consul.d \
    --name=client \
    danielehc/consul-learn-image:${IMAGE_TAG} \
    consul agent \
     -node=client-1 \
     -join=${SERVER_IP} \
     -config-file=/etc/consul.d/agent.hcl \
     -config-file=/etc/consul.d/svc-client.hcl
```

## Build

### Tweak image

The `Makefile` permits you to define the version of the applications to use as well as the Docker repository:

```
DOCKER_REPOSITORY=danielehc/consul-learn-image
CONSUL_VERSION=1.8.3
ENVOY_VERSION=1.15.0
FAKEAPP_VERSION=0.17.6
COUNTER_VERSION=0.0.3
DASHBOARD_VERSION=0.0.3
```

edit the `Makefile` to adjust the versions you want.

### Build the image

```
make build
```

### Deploy to Docker

```
docker login --username=danielehc
```

```
Password: 
WARNING! Your password will be stored unencrypted in /home/daniele/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

```
make build_and_push
```


[consul]:https://www.consul.io/
[envoy]:https://www.envoyproxy.io/
[docker]:https://www.docker.com/

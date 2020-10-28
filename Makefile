.PHONY: build build_and_push
DOCKER_REPOSITORY=danielehc/consul-learn-image
CONSUL_VERSION=1.8.3
ENVOY_VERSION=1.15.0
FAKEAPP_VERSION=0.17.6
COUNTER_VERSION=0.0.3
DASHBOARD_VERSION=0.0.3

## Add more powerful option to build the binary or react if does not exist
consul:
	test -f ./binaries/consul/$@-${CONSUL_VERSION} || { curl -s https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip; unzip -p /tmp/consul_${CONSUL_VERSION}_linux_amd64.zip consul >./binaries/consul/$@-${CONSUL_VERSION}; chmod +x ./binaries/consul/$@-${CONSUL_VERSION};}

fake-service:
	test -f ./binaries/apps/fake-service-${FAKEAPP_VERSION} || { curl -sL https://github.com/nicholasjackson/fake-service/releases/download/v${FAKEAPP_VERSION}/fake-service-linux -o ./binaries/apps/fake-service-${FAKEAPP_VERSION}; chmod +x ./binaries/apps/fake-service-${FAKEAPP_VERSION};}

counting-service:
	test -f ./binaries/apps/counting-service-${COUNTER_VERSION} || { curl -sL https://github.com/hashicorp/demo-consul-101/releases/download/${COUNTER_VERSION}/counting-service_linux_amd64.zip -o /tmp/counting-service_${COUNTER_VERSION}_linux_amd64.zip; unzip -p /tmp/counting-service_${COUNTER_VERSION}_linux_amd64.zip ../counting-service_linux_amd64 >./binaries/apps/counting-service-${COUNTER_VERSION}; chmod +x ./binaries/apps/counting-service-${COUNTER_VERSION};}

dashboard-service:
	test -f ./binaries/apps/dashboard-service-${DASHBOARD_VERSION} || { curl -sL https://github.com/hashicorp/demo-consul-101/releases/download/${DASHBOARD_VERSION}/dashboard-service_linux_amd64.zip -o /tmp/dashboard-service_${DASHBOARD_VERSION}_linux_amd64.zip; unzip -p /tmp/dashboard-service_${DASHBOARD_VERSION}_linux_amd64.zip ../dashboard-service_linux_amd64 >./binaries/apps/dashboard-service-${DASHBOARD_VERSION}; chmod +x ./binaries/apps/dashboard-service-${DASHBOARD_VERSION};}

download: consul fake-service counting-service dashboard-service

build: download
	docker build \
	--build-arg CONSUL_VERSION=${CONSUL_VERSION} \
	--build-arg ENVOY_VERSION=${ENVOY_VERSION} \
	--build-arg FAKEAPP_VERSION=${FAKEAPP_VERSION} \
	--build-arg COUNTER_VERSION=${COUNTER_VERSION} \
	--build-arg DASHBOARD_VERSION=${DASHBOARD_VERSION} \
	-t "${DOCKER_REPOSITORY}:v${CONSUL_VERSION}-v${ENVOY_VERSION}" .

build_and_push: build
	docker push "${DOCKER_REPOSITORY}:v${CONSUL_VERSION}-v${ENVOY_VERSION}"

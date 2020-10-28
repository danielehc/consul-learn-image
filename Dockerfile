ARG ENVOY_VERSION

## Starting from Envoy image

FROM envoyproxy/envoy-alpine:v${ENVOY_VERSION}

ENV CONSUL_HTTP_ADDR=http://localhost:8500

ARG CONSUL_VERSION
ARG FAKEAPP_VERSION
ARG COUNTER_VERSION
ARG DASHBOARD_VERSION

## Copy binaries

COPY ./binaries/consul/consul-${CONSUL_VERSION} /usr/local/bin/consul
COPY ./binaries/apps/fake-service-${FAKEAPP_VERSION} /usr/local/bin/fake-service
COPY ./binaries/apps/counting-service-${COUNTER_VERSION} /usr/local/bin/counting-service
COPY ./binaries/apps/dashboard-service-${DASHBOARD_VERSION} /usr/local/bin/dashboard-service

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

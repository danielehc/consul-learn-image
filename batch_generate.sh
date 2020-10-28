#!/bin/bash

## Warning: NOT WORKING YET

consul_version=("1.8.4" "1.7.4" "1.7.3" "1.7.2")
envoy_version=("1.15.0" "1.14.2" "1.13.2" "1.13.1" "1.12.4" "1.12.3" "1.11.2" "1.10.0")

for c in ${consul_version[@]};do
	for e in ${envoy_version[@]};do
		docker build --build-arg CONSUL_VERSION=$c --build-arg ENVOY_VERSION=$e -t danielehc/consul-learn-image:v$c-v$e	.
		docker push danielehc/consul-learn-image:v$c-v$e
	done
done
 

#!/bin/bash
docker run -d -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h consul --name consul progrium/consul -server -advertise $DOCKER_IP -bootstrap
docker run -d -v /var/run/docker.sock:/tmp/docker.sock --name registrator -h registrator gliderlabs/registrator:latest consul://$DOCKER_IP:8500
docker run -d -P --name node1 -h node1 jlordiales/python-micro-service:latest
docker run -d -P --name node2 -h node2 jlordiales/python-micro-service:latest
docker run -d -P --name node3 -h node3 jlordiales/python-micro-service:latest

docker run -p 8080:80 -d --name nginx --volume /Users/jose.ordiales/git/personal/docker-nginx-consul/service.ctmpl:/templates/service.ctmpl --link consul:consul jlordiales/nginx-consul

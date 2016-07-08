
This image is intended to be run together with Consul and Consul-Template in
order to get transparent and dynamic load balancing as new containers are
started/stopped.

Steps to RUN 

Set Environment Variable 


export DOCKER_IP=$(hostname -i)
echo $DOCKER_IP;

RUN Consul cluster on First Machine 
docker run  -v /mnt:/data -p 8400:8400 -d -p 8300:8300 -p 8301:8301 -p 8301:8301/udp -p 8302:8302/udp -p 8302:8302 -p 8500:8500 -p 53:53/udp -h node1 --name consul  progrium/consul -server -advertise $DOCKER_IP  -bootstrap-expect 1

RUN Registrator 
docker run -d -v /var/run/docker.sock:/tmp/docker.sock --name registrator -h registrator gliderlabs/registrator:latest consul://$DOCKER_IP:8500

Run Consul Cluster on Second Machine 
docker run  -v /mnt:/data -p 8400:8400 -d -p 8300:8300 -p 8301:8301 -p 8301:8301/udp -p 8302:8302/udp -p 8302:8302 -p 8500:8500 -p 53:53/udp -h node2 --name consul  progrium/consul -server -advertise $DOCKER_IP -join 10.0.0.187  


Creeate Python Application SErvice 
On First consul cluster
docker run -d -P  -h node1 jlordiales/python-micro-service:latest

On second consul cluster
docker run -d -P  -h node2 jlordiales/python-micro-service:latest

Run Nginx + 
docker run -d -P -v /home/ubuntu/nginx-consul-template/service.ctmpl:/templates/service.ctmpl -v /home/ubuntu/nginx-consul-template/nginx.conf:/etc/nginx/nginx.conf  --link consul:consul abhijeetka/nginx-org

Access URL's
/python-micro-service/ = For Python Service 
/status/ = For Nginx Dashboard
/lua/ = For Lua service 

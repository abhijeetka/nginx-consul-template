FROM ubuntu:14.04

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

# Set the debconf front end to Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y -q wget apt-transport-https

# Download certificate and key from the customer portal (https://cs.nginx.com)
# and copy to the build context
ADD nginx-repo.crt /etc/ssl/nginx/
ADD nginx-repo.key /etc/ssl/nginx/

# Get other files required for installation
RUN wget -q -O /etc/ssl/nginx/CA.crt https://cs.nginx.com/static/files/CA.crt
RUN wget -q -O - http://nginx.org/keys/nginx_signing.key | apt-key add -
RUN wget -q -O /etc/apt/apt.conf.d/90nginx https://cs.nginx.com/static/files/90nginx

RUN printf "deb https://plus-pkgs.nginx.com/ubuntu `lsb_release -cs` nginx-plus\n" >/etc/apt/sources.list.d/nginx-plus.list

# Install NGINX Plus
RUN apt-get update && apt-get install -y nginx-plus nginx-plus-module-lua unzip nginx-plus-module-headers-more

# forward request logs to Docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ADD start.sh /bin/start.sh
ADD https://releases.hashicorp.com/consul-template/0.7.0/consul-template_0.7.0_linux_amd64.zip /usr/local/bin/
RUN unzip /usr/local/bin/consul-template_0.7.0_linux_amd64.zip

ADD status.conf /etc/nginx/conf.d/

ENV CONSUL_URL consul:8500
VOLUME /templates
EXPOSE 80 443

ENTRYPOINT ["/bin/start.sh"]
#CMD ["nginx", "-g", "daemon off;"]

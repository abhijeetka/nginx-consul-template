FROM nginx:latest

RUN apt-get update && apt-get install -y unzip zip

ENTRYPOINT ["/bin/start.sh"]
EXPOSE 80
VOLUME /templates
ENV CONSUL_URL consul:8500

ADD start.sh /bin/start.sh
RUN rm -v /etc/nginx/conf.d/*.conf

ADD https://releases.hashicorp.com/consul-template/0.7.0/consul-template_0.7.0_linux_amd64.zip /usr/local/bin/
RUN unzip /usr/local/bin/consul-template_0.7.0_linux_amd64.zip

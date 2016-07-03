#!/bin/bash
service nginx start
cd /usr/local/bin/
ls -lrt
unzip *.zip
consul-template --version
consul-template -consul=$CONSUL_URL -template="/templates/service.ctmpl:/etc/nginx/conf.d/service.conf:service nginx reload"

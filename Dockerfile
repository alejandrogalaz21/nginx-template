FROM jwilder/docker-gen:latest
COPY nginx.tmpl /etc/docker-gen/templates/nginx.tmpl
COPY vhost.d /etc/nginx/vhost.d
COPY htpasswd /etc/nginx/htpasswd
COPY default.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT ["/usr/local/bin/docker-gen"]
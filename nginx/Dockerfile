FROM    nginx:alpine

LABEL maintainer="benoit.pourre@doca-consulting.fr"
LABEL app.kubernetes.io/version="3.4.1"
LABEL app.kubernetes.io/managed-by="Helm"
LABEL app.kubernetes.io/part-of="code-server-hub"
LABEL app.kubernetes.io/component="nginx"
LABEL source="https://gitlab.com/captnbp/code-server-hub"

COPY	./nginx.conf	/etc/nginx/nginx.conf

RUN     chmod -R 770 /var/cache/nginx
RUN     chmod -R 777 /var/run

COPY docker-entrypoint.sh   /usr/local/bin/docker-entrypoint.sh

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off"]
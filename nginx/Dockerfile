FROM    nginx:alpine

COPY	./nginx.conf	/etc/nginx/nginx.conf

RUN     chown -R nginx:root /var/cache/nginx/ && chmod -R 777 /var/cache/nginx
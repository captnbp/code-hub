FROM    nginx:alpine

COPY	./nginx.conf	/etc/nginx/nginx.conf

RUN     chmod -R 770 /var/cache/nginx
RUN     mkdir /var/run && chmod 777 /var/run
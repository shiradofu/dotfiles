FROM nginx:1.21-alpine
ARG FASTCGI_HOST=127.0.0.1
COPY docker/web/default.conf.tpl /etc/nginx/conf.d/default.conf.tpl
RUN envsubst '$$FASTCGI_HOST' < /etc/nginx/conf.d/default.conf.tpl > /etc/nginx/conf.d/default.conf

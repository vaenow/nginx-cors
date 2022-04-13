FROM nginx

RUN apt-get update && apt-get install -y unzip vim
RUN apt-get install -y tree


COPY index.html /app/dist/

COPY nginx.conf /etc/nginx/nginx.conf

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx-*.conf /etc/nginx/conf.d/

ENV NGINX_PROXY_CACHE_VALID_TIME 6s
CMD sed -i.bak s/__NGINX_PROXY_CACHE_VALID_TIME__/$NGINX_PROXY_CACHE_VALID_TIME/g /etc/nginx/conf.d/nginx-cors.conf && nginx -g "daemon off;"

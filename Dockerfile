FROM nginx

RUN apt-get update && apt-get install -y unzip vim
RUN apt-get install -y tree


COPY index.html /app/dist/

COPY nginx.conf /etc/nginx/nginx.conf

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx-cache.conf /etc/nginx/conf.d/
COPY conf/nginx-cors-*.conf /etc/nginx/cors/
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENV NGINX_PROXY_CACHE_VALID_TIME 3s
ENV CORS_MODE dispatcher

ENTRYPOINT ["/docker-entrypoint.sh"]

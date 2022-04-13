FROM nginx

RUN apt-get update && apt-get install -y unzip vim
RUN apt-get install -y tree


COPY index.html /app/dist/

COPY nginx.conf /etc/nginx/nginx.conf

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx-*.conf /etc/nginx/conf.d/

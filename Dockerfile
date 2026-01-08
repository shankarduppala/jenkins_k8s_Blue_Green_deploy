FROM nginx:alpine

ARG VERSION 
ENV VERSION=${VERSION}

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80 
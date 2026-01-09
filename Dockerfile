FROM nginx:alpine

ARG ENV
ENV ENV=${ENV}

COPY index.html /usr/share/nginx/html/index.html

RUN sed -i "s/\${ENV}/${ENV}/g" /usr/share/nginx/html/index.html
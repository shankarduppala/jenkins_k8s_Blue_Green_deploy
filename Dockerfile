FROM nginx:alpine

ARG ENV
ENV ENV=${ENV}

COPY app/index.html /usr/share/nginx/html/index.html

RUN if [ "$ENV" = "blue" ]; then \
      COLOR="#1e90ff"; \
      LABEL="BLUE"; \
    else \
      COLOR="#2ecc71"; \
      LABEL="GREEN"; \
    fi && \
    sed -i "s/\${ENV}/$LABEL/g" /usr/share/nginx/html/index.html && \
    sed -i "s/\${BG_COLOR}/$COLOR/g" /usr/share/nginx/html/index.html
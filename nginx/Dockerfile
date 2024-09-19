FROM nginx:latest AS base

# make the letsencrypt dir and change owner
RUN mkdir -p /var/www/_letsencrypt

FROM base AS build
COPY ./nginx /etc/nginx/
COPY run.sh /
RUN chown nginx:nginx /run.sh && chmod +x /run.sh

FROM build AS runner

CMD /run.sh
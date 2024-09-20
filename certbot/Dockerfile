# https://certbot.eff.org/instructions?ws=nginx&os=pip&tab=wildcard
FROM debian:latest AS base

RUN apt update

FROM base AS build

RUN apt install -y python3 python3-venv libaugeas0

RUN python3 -m venv /opt/certbot/

RUN /opt/certbot/bin/pip install --upgrade pip

RUN /opt/certbot/bin/pip install certbot

RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot

RUN /opt/certbot/bin/pip install certbot-dns-cloudflare

FROM build AS runner

ENTRYPOINT certbot
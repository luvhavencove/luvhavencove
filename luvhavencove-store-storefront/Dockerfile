FROM node:lts AS base
RUN groupmod -g 1001 node && usermod -u 1001 -g 1001 node
WORKDIR /app

# download all deps
FROM base AS ci
COPY package.json package-lock.json /app/
RUN npm ci

# copy over src files to dev
FROM base AS install
COPY --from=ci /app/node_modules node_modules
COPY . /app/

FROM install AS build
RUN chown -R 1001:1001 /app
RUN chmod +x /app/run.sh

# RUN mkdir -p /data/public && chown -R 1001:1001 /data/public
USER node

ENTRYPOINT /app/run.sh

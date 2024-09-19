FROM node:lts AS base
RUN apt-get -y update && apt-get -y install curl jq
WORKDIR /app

# download all deps
FROM base AS ci
COPY package.json package-lock.json /app/
RUN npm ci --verbose

# copy over src files to dev
FROM base AS install
COPY --from=ci /app/node_modules node_modules
COPY . /app/

FROM install AS build
RUN chown -R node:node /app && chmod +x /app/run.sh

RUN mkdir -p /data/shared && chown -R node:node /data/shared
RUN mkdir -p /data/public && chown -R node:node /data/public

FROM build AS runner

USER node

ENTRYPOINT /app/run.sh
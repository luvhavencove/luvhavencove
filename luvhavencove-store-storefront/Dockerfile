FROM node:lts AS base
USER node
WORKDIR /app

# download all deps
FROM base AS ci
COPY package.json package-lock.json /app/
RUN npm ci --verbose

# copy over src files to dev
FROM base AS install
COPY --from=ci /app/node_modules node_modules

FROM install AS postinstall
COPY --chown=node:node . /app/

FROM postinstall AS setup
RUN chmod +x /app/run.sh

FROM setup AS runner

ENTRYPOINT /app/run.sh

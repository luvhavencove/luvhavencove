FROM node:lts AS base
# RUN groupmod -g 1001 node && usermod -u 1001 -g 1001 node
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

FROM build AS runner

USER node

ENTRYPOINT /app/run.sh

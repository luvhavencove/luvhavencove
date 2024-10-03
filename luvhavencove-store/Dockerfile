FROM node:lts AS base
RUN apt update && apt install bash curl jq
SHELL [ "bash", "-c" ]

RUN groupmod -g 1001 node
RUN usermod -u 1001 node

# Use bash for brace expansion
RUN install -o node -g node -m 755 -d /data/{shared,public}
USER node
WORKDIR /app

FROM base AS ci
COPY package.json package-lock.json /app/
RUN npm ci --verbose

FROM base AS ci-development
COPY package.json package-lock.json /app/
RUN npm ci --verbose

FROM base AS build
COPY --from=ci-development --chown=node:node /app/node_modules node_modules
COPY --chown=node:node . /app/
RUN npm run build

FROM base AS postbuild
COPY --from=ci --chown=node:node /app/node_modules node_modules
COPY --chown=node:node . /app/
RUN find . -type f -name "*.template" | sed "s#.template##" | xargs -I % bash -c "cp -a %.template %"
RUN chmod +x /app/run.sh

FROM postbuild AS production

ENTRYPOINT [ "/app/run.sh" ]

FROM base AS setup-dev
COPY --from=ci-development --chown=node:node /app/node_modules node_modules
COPY --chown=node:node . /app/
RUN chmod +x /app/run.sh

FROM setup-dev AS development

ENTRYPOINT [ "/app/run.sh" ]

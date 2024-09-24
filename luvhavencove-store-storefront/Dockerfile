FROM node:lts AS base
ARG NODE_ENV
ENV NODE_ENV ${NODE_ENV}
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

USER node
WORKDIR /app

FROM base AS ci
COPY package.json package-lock.json /app/
RUN npm ci --verbose

FROM base AS install
COPY --from=ci /app/node_modules node_modules

FROM install AS postinstall
COPY --chown=node:node . /app/
RUN find . -type f -name "*.template" | sed "s#.template##" | xargs -I % bash -c "cp -a %.template %"

FROM postinstall AS setup
RUN chmod +x /app/run.sh

FROM setup AS runner

ENTRYPOINT [ "/app/run.sh" ]

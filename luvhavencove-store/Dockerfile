FROM node:lts AS base
RUN apt-get -y update && apt-get -y install curl jq
# Use bash for brace expansion
RUN /bin/bash -c "install -o node -g node -m 755 -d /data/{shared,public}"
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
FROM alpine AS base
RUN apk update && apk add bash curl jq
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN adduser -D runner
WORKDIR /app
RUN install -o runner -g runner -m 755 -d /data/{shared,public}

FROM base AS copy
COPY . .
RUN chown -R runner:runner /app
RUN chmod -R +x /app/run.sh

FROM copy AS runner

CMD /app/run.sh
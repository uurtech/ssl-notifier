FROM bash

RUN apk update
RUN apk add curl
RUN apk add --update coreutils && rm -rf /var/cache/apk/*
WORKDIR /app
COPY . .
ENTRYPOINT [ "bash","./notifier.sh"]
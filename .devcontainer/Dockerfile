# syntax=docker/dockerfile:1
FROM google85/devcontainer-go:1.24.3

ENV TZ="Europe/Bucharest"

# Required for resources, instead of windres
RUN go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest

WORKDIR /usr/src/app

ENTRYPOINT [ "/bin/bash" ]

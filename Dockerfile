# syntax=docker/dockerfile:1
ARG GO_VERSION=1.24.3

FROM golang:${GO_VERSION}-bullseye AS builder

ENV TZ="Europe/Bucharest"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl git sudo && \
    apt-get upgrade -y --no-install-recommends \
        openssl mercurial && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN set -eux; \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -c "VsCode user" -s /bin/bash  -m $USERNAME && \
    mkdir -p /etc/sudoers.d && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir -p /usr/src/app && \
    chown -R 1000:1000 /go /usr/src/app

USER ${USERNAME}

# Required for resources, instead of windres
RUN go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest

RUN git config --global --add safe.directory /usr/src/app
#ENV GOPRIVATE=github.com/google85

WORKDIR /usr/src/app

COPY --chown=1000:1000 go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod,uid=1000,gid=1000 \
    go mod download
RUN --mount=type=cache,target=/go/pkg/mod,uid=1000,gid=1000 \
    go mod tidy

COPY --chown=1000:1000 . .

RUN --mount=type=cache,target=/go/pkg/mod,uid=1000,gid=1000 \
    make build

###

FROM scratch AS binary

WORKDIR /
COPY --from=builder /usr/src/app/bin/msgbox_syswin.exe        /msgbox_syswin.exe
COPY --from=builder /usr/src/app/bin/msgbox_syscall.exe       /msgbox_syscall.exe

###

FROM alpine:3.18

WORKDIR /usr/local/bin
COPY --from=builder /usr/src/app/bin/msgbox_syswin.exe        /usr/local/bin/msgbox_syswin.exe
COPY --from=builder /usr/src/app/bin/msgbox_syscall.exe       /usr/local/bin/msgbox_syscall.exe

ENTRYPOINT ["/usr/local/bin/msgbox_syscall.exe"]

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.license="proprietary" \
      org.label-schema.name="MsgBox go app" \
      org.label-schema.description="MsgBox app written in Go" \
      maintainer="google85 <bpfcomp2005@gmail.com>" \
      go.version="1.24.3" \
      build.go.version="1.24.3" \
      org.label-schema.url="https://github.com/google85/go-windows-messagebox" \
      org.label-schema.vcs-url="https://github.com/google85/go-windows-messagebox" \
      org.label-schema.cmd="./hello-cli" \
      org.opencontainers.image.vendor="google85" \
      org.opencontainers.image.title="MsgBox go app" \
      org.opencontainers.image.description="MsgBox app written in Go" \
      org.opencontainers.image.authors="google85 <bpfcomp2005@gmail.com>" \
      org.opencontainers.image.source="https://github.com/google85/go-windows-messagebox" \
      org.opencontainers.image.url="https://github.com/google85/go-windows-messagebox" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.created="2026-08-21"
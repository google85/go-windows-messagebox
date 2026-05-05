# syntax=docker/dockerfile:1
ARG GO_VERSION=1.24.3

FROM golang:${GO_VERSION}-bullseye

ENV TZ="Europe/Bucharest"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl wget git sudo ssh ca-certificates && \
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

# Required for Go extension
RUN go install golang.org/x/tools/gopls@v0.20.0

RUN git config --global --add safe.directory /usr/src/app
#ENV GOPRIVATE=github.com/google85

WORKDIR /usr/src/app

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.license="proprietary" \
      org.label-schema.name="Go devcontainer" \
      org.label-schema.description="Go devcontainer" \
      maintainer="google85 <bpfcomp2005@gmail.com>" \
      go.version="1.24.3" \
      build.go.version="1.24.3" \
      org.label-schema.url="https://github.com/google85/" \
      org.label-schema.vcs-url="https://github.com/google85/" \
      org.label-schema.cmd="/bin/bash" \
      org.opencontainers.image.vendor="google85" \
      org.opencontainers.image.title="Go devcontainer" \
      org.opencontainers.image.description="Go devcontainer" \
      org.opencontainers.image.authors="google85 <bpfcomp2005@gmail.com>" \
      org.opencontainers.image.source="https://github.com/google85/" \
      org.opencontainers.image.url="https://github.com/google85/" \
      org.opencontainers.image.version="1.0.0" \
      org.opencontainers.image.created="2026-05-05"

ENTRYPOINT [ "/bin/bash" ]

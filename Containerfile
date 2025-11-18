# Base image for building reftable in a Container with Engflow warm bazel.

# Engflow run-tests specifically tests for the Debian release. 
FROM debian:bookworm

# Architecture for bazelisk binary (e.g., amd64 or arm64); provided by build args
ARG BAZELISK_ARCH

# clang, gcc, valgrind: reftable repo
# python3: engflow repo 
# strace, procps, file: debugging 
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        bash \
	bind9-host \
	ca-certificates \
	clang \
	curl \
	file \
	gcc \
	git \
	less \
	openssh-client \
	procps \
	python3 \
	sudo \
	strace \
	time \
	valgrind \
	wget

RUN : "${BAZELISK_ARCH?Set BAZELISK_ARCH build-arg to amd64 or arm64}" && \
    wget -O /usr/bin/bazelisk "https://github.com/bazelbuild/bazelisk/releases/download/v1.22.0/bazelisk-linux-${BAZELISK_ARCH}" && \
    chmod +x /usr/bin/bazelisk && \
    ln -s bazelisk /usr/bin/bazel

# Engflow CI asserts that docker is there, but inside Podman it's not
# going to work.
RUN ln -s /usr/bin/true /usr/local/bin/docker

# Sudo groups: admin on ubuntu, sudo on debian.
RUN mkdir /myhomedir &&  \
    groupadd -g 1492 build && \
    groupadd -g 1493 admin && \
    useradd -u 1492 -p '' -d /myhomedir -m -g build -G sudo,admin build && \
    chown build:build /myhomedir && \
    true
USER build
WORKDIR /myhomedir

# 8.2.1 for the hanwen-flow/reftable repo
RUN mkdir bazelisk && cd bazelisk && touch MODULE.bazel && \
   echo 8.2.1 > .bazelversion && (bazelisk || true) 

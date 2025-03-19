
ARG ZIG_VERSION=0.14.0
ARG BASE_IMAGE=ubuntu:24.04
ARG ARCH=x86_64

FROM ubuntu:24.04 AS builder
# need to specify the ARG again to make it available in this stage
ARG ZIG_VERSION
ARG ARCH
RUN apt-get update && apt-get install -y curl
RUN apt-get install -y xz-utils 
RUN curl -L https://builds.zigtools.org/zls-linux-${ARCH}-${ZIG_VERSION}.tar.xz -o /tmp/zls.tar.xz
RUN mkdir /tmp/zls
RUN tar -xvf /tmp/zls.tar.xz -C /tmp/zls
RUN mv /tmp/zls /root/.zls

RUN curl -L https://ziglang.org/download/${ZIG_VERSION}/zig-linux-${ARCH}-${ZIG_VERSION}.tar.xz -o /tmp/zig.tar.xz
RUN tar -xvf /tmp/zig.tar.xz --one-top-level=/root/.zig

FROM $BASE_IMAGE
ARG ARCH
ARG ZIG_VERSION
COPY --from=builder --chown=root:root --chmod=0555 /root/.zls /usr/local/zls
COPY --from=builder --chown=root:root --chmod=0555 /root/.zig /usr/local/zig
ENV PATH="/usr/local/zls:${PATH}"
ENV PATH="/usr/local/zig/zig-linux-${ARCH}-${ZIG_VERSION}:${PATH}"




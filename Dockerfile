# Base image containing dependencies used in builder and final image
FROM ghcr.io/swissgrc/azure-pipelines-dockercli:28.0.0 AS base

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_12/curl versioning=loose
ENV CURL_VERSION=7.88.1-10+deb12u8
# renovate: datasource=repology depName=debian_12/lsb-release versioning=loose
ENV LSBRELEASE_VERSION=12.0-1
# renovate: datasource=repology depName=debian_12/gnupg2 versioning=loose
ENV GNUPG_VERSION=2.2.40-1.1

RUN apt-get update -y && \
  # Install necessary dependencies
  apt-get install -y --no-install-recommends \
    curl=${CURL_VERSION} \
    gnupg=${GNUPG_VERSION} \
    lsb-release=${LSBRELEASE_VERSION} && \
  # Add Git LFS PPA
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

# renovate: datasource=github-tags depName=git/git extractVersion=^v(?<version>.*)$
ENV GIT_VERSION=2.48.1

# renovate: datasource=repology depName=debian_12/build-essential-mipsen versioning=loose
ENV BUILDESSENTIAL_VERSION=12.9
# renovate: datasource=repology depName=debian_12/dh-autoreconf versioning=loose
ENV DHAUTORECONF_VERSION=20
# renovate: datasource=repology depName=debian_12/zlib versioning=loose
ENV LIBZ_VERSION=1.2.13.dfsg
# renovate: datasource=repology depName=debian_12/gettext versioning=loose
ENV GETTEXT_VERSION=0.21-12
ENV LIBSSL_VERSION=3.0.15-1~deb12u1
# renovate: datasource=repology depName=debian_12/curl versioning=loose
ENV LIBCURLDEV_VERSION=7.88.1-10+deb12u8
ENV LIBEXPAT_VERSION=2.5.0-1+deb12u1

# Download and extract Git source code
ADD https://github.com/git/git/archive/refs/tags/v${GIT_VERSION}.tar.gz /tmp/git.tar.gz
WORKDIR /tmp
RUN tar -zxf git.tar.gz 
# Build Git from source
WORKDIR /tmp/git-${GIT_VERSION} 
RUN apt-get install -y --no-install-recommends \
  build-essential=${BUILDESSENTIAL_VERSION} \
  dh-autoreconf=${DHAUTORECONF_VERSION} \
  gettext=${GETTEXT_VERSION} \
  libcurl4-gnutls-dev=${LIBCURLDEV_VERSION} \
  libexpat1-dev=${LIBEXPAT_VERSION} \
  libssl-dev=${LIBSSL_VERSION} \
  zlib1g-dev=1:${LIBZ_VERSION}-1 && \
  make configure && \
  ./configure --prefix=/usr && \ 
  make all && \ 
  make install && \ 
  # Smoke test
  git version

# Final image
FROM base AS final

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-git"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-git"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /

# Install Git LFS

# Copy Git LFS keyring
COPY --from=build /etc/apt/keyrings/ /etc/apt/keyrings
COPY --from=build /etc/apt/sources.list.d/ /etc/apt/sources.list.d

# renovate: datasource=github-tags depName=git-lfs/git-lfs extractVersion=^v(?<version>.*)$
ENV GITLFS_VERSION=3.6.1

RUN apt-get update -y && \
  # Install Git LFS
  # This will also install Git as dependency which will be overwritten later 
  apt-get install -y --no-install-recommends git-lfs=${GITLFS_VERSION} && \
  # Smoke test
  git lfs version

# Install Git 

# renovate: datasource=repology depName=debian_12/curl versioning=loose
ENV LIBCURL_VERSION=7.88.1-10+deb12u8

# Install necessary dependencies
RUN apt-get install -y --no-install-recommends libcurl3-gnutls=${LIBCURL_VERSION}

# Copy Git
COPY --from=build /usr/bin/git /usr/bin/git
COPY --from=build /usr/libexec/git-core /usr/libexec/git-core
COPY --from=build /usr/share/git-core/templates /usr/share/git-core/templates

# Smoke test & cleanup
RUN git version && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Base image containing dependencies used in builder and final image
FROM ghcr.io/swissgrc/azure-pipelines-dockercli:24.0.6 AS base

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_12/curl versioning=loose
ENV CURL_VERSION=7.88.1-10+deb12u1
# renovate: datasource=repology depName=debian_12/lsb-release versioning=loose
ENV LSBRELEASE_VERSION=12.0-1
# renovate: datasource=repology depName=debian_12/gnupg2 versioning=loose
ENV GNUPG_VERSION=2.2.40-1.1

RUN apt-get update -y && \
  # Install necessary dependencies
  apt-get install -y --no-install-recommends curl=${CURL_VERSION} lsb-release=${LSBRELEASE_VERSION} gnupg=${GNUPG_VERSION} && \
  # Add Git LFS PPA
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

# Final image
FROM base AS final

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-git"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-git"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /
# Copy Git LFS keyring
COPY --from=build /etc/apt/keyrings/ /etc/apt/keyrings
COPY --from=build /etc/apt/sources.list.d/ /etc/apt/sources.list.d

# renovate: datasource=repology depName=debian_12_backports/git versioning=loose
ENV GIT_VERSION=1:2.39.2-1.1

RUN apt-get update -y && \
  # Install Git
  apt-get install -y --no-install-recommends git=${GIT_VERSION} && \
  # Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  git version

# Install Git LFS

# renovate: datasource=github-tags depName=git-lfs/git-lfs extractVersion=^v(?<version>.*)$
ENV GITLFS_VERSION=3.4.0

RUN apt-get update -y && \
  # Install Git LFS
  apt-get install -y --no-install-recommends git-lfs=${GITLFS_VERSION}  && \
  # Clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  # Smoke test
  git lfs version

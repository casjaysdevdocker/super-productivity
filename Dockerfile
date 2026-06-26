# syntax=docker/dockerfile:1
# - - - - - - - - - - - - - - - - - - - - - - - - -
# Super-Productivity Docker Image
# https://github.com/casjaysdevdocker/super-productivity
# - - - - - - - - - - - - - - - - - - - - - - - - -

ARG PULL_URL="casjaysdev/alpine"
ARG DISTRO_VERSION="latest"

# ── Stage 0: pre-built super-productivity web assets ──
FROM johannesjo/super-productivity:latest AS sp-app

# ── Stage 1: gosu binary ──────────────────────────────
FROM tianon/gosu:latest AS gosu

# ── Stage 2: Build stage ──────────────────────────────
FROM ${PULL_URL}:${DISTRO_VERSION} AS build

ARG IMAGE_NAME="super-productivity"
ARG PHP_SERVER="super-productivity"
ARG BUILD_DATE="202501010000"
ARG LANGUAGE="en_US.UTF-8"
ARG TIMEZONE="America/New_York"
ARG WWW_ROOT_DIR="/usr/local/share/httpd/default"
ARG PATH="/usr/local/etc/docker/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ARG USER="root"
ARG SHELL_OPTS="set -e -o pipefail"
ARG SERVICE_PORT="80"
ARG EXPOSE_PORTS="80"
ARG PHP_VERSION="system"
ARG NODE_VERSION="system"
ARG NODE_MANAGER="system"
ARG IMAGE_REPO="casjaysdevdocker/super-productivity"
ARG IMAGE_VERSION="latest"
ARG CONTAINER_VERSION="${IMAGE_VERSION}"
ARG BUILD_VERSION="${BUILD_DATE}"

ENV ENV="~/.profile" \
    SHELL="/bin/sh" \
    PATH="${PATH}" \
    TZ="${TIMEZONE}" \
    TIMEZONE="${TIMEZONE}" \
    LANG="${LANGUAGE}" \
    TERM="xterm-256color" \
    HOSTNAME="casjaysdevdocker-${IMAGE_NAME}"

COPY ./rootfs/. /

RUN pkmgr update && pkmgr install bash ca-certificates nginx jq curl && update-ca-certificates && \
    rm -rf /etc/postfix /etc/ssmtp

ENV SHELL="/bin/bash"
SHELL ["/bin/bash", "-c"]

COPY --from=gosu  /usr/local/bin/gosu              /usr/local/bin/gosu
COPY --from=sp-app /usr/share/nginx/html/           /usr/local/share/httpd/default/

RUN chmod -Rf 755 /root/docker/setup && \
    /root/docker/setup/00-init.sh && \
    /root/docker/setup/01-system.sh && \
    /root/docker/setup/02-packages.sh && \
    /root/docker/setup/03-files.sh && \
    /root/docker/setup/04-users.sh && \
    /root/docker/setup/05-custom.sh && \
    /root/docker/setup/06-post.sh && \
    /root/docker/setup/07-cleanup.sh && \
    chmod -Rf 755 /usr/local/etc/docker/init.d && \
    chmod +x /usr/local/bin/entrypoint.sh \
             /usr/local/bin/pkmgr

# ── Stage 3: Final minimal image ─────────────────────
FROM scratch

ARG BUILD_DATE="202501010000"
ARG GIT_COMMIT=""
ARG IMAGE_NAME="super-productivity"
ARG IMAGE_VERSION="latest"
ARG BUILD_VERSION="${BUILD_DATE}"
ARG LANGUAGE="en_US.UTF-8"
ARG TIMEZONE="America/New_York"
ARG WWW_ROOT_DIR="/usr/local/share/httpd/default"
ARG PATH="/usr/local/etc/docker/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ARG USER="root"
ARG SERVICE_PORT="80"
ARG LICENSE="WTFPL"
ARG ENV_PORTS="80"
ARG TZ="America/New_York"

LABEL maintainer="CasjaysDev <docker-admin@casjaysdev.pro>" \
      org.opencontainers.image.vendor="CasjaysDev" \
      org.opencontainers.image.authors="CasjaysDev" \
      org.opencontainers.image.description="Containerized version of super-productivity" \
      org.opencontainers.image.title="${IMAGE_NAME}" \
      org.opencontainers.image.base.name="${IMAGE_NAME}" \
      org.opencontainers.image.licenses="${LICENSE}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.version="${BUILD_VERSION}" \
      org.opencontainers.image.schema-version="${BUILD_VERSION}" \
      org.opencontainers.image.url="https://hub.docker.com/r/casjaysdevdocker/super-productivity" \
      org.opencontainers.image.source="https://github.com/casjaysdevdocker/super-productivity" \
      org.opencontainers.image.vcs-type="Git" \
      org.opencontainers.image.revision="${GIT_COMMIT}" \
      org.opencontainers.image.documentation="https://github.com/casjaysdevdocker/super-productivity" \
      com.github.containers.toolbox="false"

ENV ENV="~/.bashrc" \
    USER="${USER}" \
    PATH="${PATH}" \
    TZ="${TZ}" \
    SHELL="/bin/bash" \
    TIMEZONE="${TIMEZONE}" \
    LANG="${LANGUAGE}" \
    TERM="xterm-256color" \
    PORT="${SERVICE_PORT}" \
    ENV_PORTS="${ENV_PORTS}" \
    CONTAINER_NAME="${IMAGE_NAME}" \
    HOSTNAME="casjaysdev-${IMAGE_NAME}" \
    WWW_ROOT_DIR="${WWW_ROOT_DIR}" \
    APP_PORT="80" \
    SYNC_INTERVAL="" \
    IS_COMPRESSION_ENABLED="" \
    IS_ENCRYPTION_ENABLED="" \
    SUPERSYNC_BASE_URL=""

COPY --from=build /. /

VOLUME ["/config", "/data"]
EXPOSE ${SERVICE_PORT} ${ENV_PORTS}
STOPSIGNAL SIGRTMIN+3
ENTRYPOINT ["tini", "-p", "SIGTERM", "--", "/usr/local/bin/entrypoint.sh"]
HEALTHCHECK --start-period=10m --interval=5m --timeout=15s \
  CMD ["/usr/local/bin/entrypoint.sh", "healthcheck"]

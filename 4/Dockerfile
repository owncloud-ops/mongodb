FROM docker.io/amd64/debian:11-slim@sha256:0781db7f3f74866059cf161d145af0bc16fb13493b6e0f87ca20d7e34498d691

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.title="MongoDB"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/mongodb"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/mongodb"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/mongodb"

ARG BUILD_VERSION
ARG CONTAINER_LIBRARY_VERSION

ARG DEBIAN_FRONTEND=noninteractive

# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ENV GOMPLATE_VERSION="${GOMPLATE_VERSION:-v3.11.5}"
# renovate: datasource=docker depName=mongo
ENV MONGO_RAW_VERSION="${BUILD_VERSION:-4.4.22}"
# renovate: datasource=github-releases depName=owncloud-ops/container-library
ENV CONTAINER_LIBRARY_VERSION="${CONTAINER_LIBRARY_VERSION:-v0.1.0}"

ENV MONGO_DATA_DIR="${MONGO_DATA_DIR:-/opt/mongo}"

ADD overlay/ /

RUN addgroup --gid 101 --system mongodb && \
    adduser --system --disabled-password --no-create-home --uid 101 --home "${MONGO_DATA_DIR}" --shell /sbin/nologin --ingroup mongodb --gecos mongodb mongodb && \
    apt-get update && apt-get install -y wget curl gnupg2 procps apt-transport-https ca-certificates && \
    curl -SsfL -o /usr/local/bin/gomplate "https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64-slim" && \
    curl -SsfL "https://github.com/owncloud-ops/container-library/releases/download/${CONTAINER_LIBRARY_VERSION}/container-library.tar.gz" | tar xz -C / && \
    chmod 755 /usr/local/bin/gomplate && \
    MONGO_VERSION=${MONGO_RAW_VERSION%.*} && \
    echo "Setup MongoDB 'v$MONGO_VERSION'" && \
    curl -SsfL "https://www.mongodb.org/static/pgp/server-$MONGO_VERSION.asc" | gpg --dearmor |\
        tee /usr/share/keyrings/mongodb-org.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/mongodb-org.gpg] https://repo.mongodb.org/apt/debian buster/mongodb-org/$MONGO_VERSION main" |\
        tee "/etc/apt/sources.list.d/mongodb-org.list" && \
    apt-get update && apt-get install -y mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools && \
    mkdir -p "${MONGO_DATA_DIR}"/db && \
    mkdir -p "${MONGO_DATA_DIR}"/dump && \
    mkdir -p "${MONGO_DATA_DIR}"/conf && \
    mkdir -p "${MONGO_DATA_DIR}"/tmp && \
    chown -R mongodb:mongodb "${MONGO_DATA_DIR}" && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME "${MONGO_DATA_DIR}"/db

EXPOSE 27017

USER mongodb

ENTRYPOINT ["/usr/bin/entrypoint", "server"]
HEALTHCHECK --interval=15s --timeout=5s --retries=10 CMD /usr/bin/healthcheck
WORKDIR "${MONGO_DATA_DIR}"
CMD []

FROM debian:9-slim@sha256:0ee501c41db93e0dc3b9b3851d3995db6ec8c66f71ef8a9fd0f52e5aa5abc2e1

LABEL maintainer="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>"
LABEL org.opencontainers.image.title="MongoDB"
LABEL org.opencontainers.image.url="https://github.com/owncloud-ops/mongodb"
LABEL org.opencontainers.image.source="https://github.com/owncloud-ops/mongodb"
LABEL org.opencontainers.image.documentation="https://github.com/owncloud-ops/mongodb"

ARG BUILD_VERSION
ARG DEBIAN_FRONTEND=noninteractive

# renovate: datasource=github-releases depName=hairyhenderson/gomplate
ENV GOMPLATE_VERSION="${GOMPLATE_VERSION:-v3.9.0}"
# renovate: datasource=docker depName=mongo
ENV MONGO_RAW_VERSION="${BUILD_VERSION:-4.0.25}"
ENV MONGO_DATA_DIR="${MONGO_DATA_DIR:-/opt/mongo}"

ADD overlay/ /

RUN addgroup --gid 101 --system mongodb && \
    adduser --system --disabled-password --no-create-home --uid 101 --home "${MONGO_DATA_DIR}" --shell /sbin/nologin --ingroup mongodb --gecos mongodb mongodb && \
    apt-get update && apt-get install -y wget curl gnupg2 procps apt-transport-https ca-certificates && \
    curl -SsL -o /usr/local/bin/gomplate "https://github.com/hairyhenderson/gomplate/releases/download/${GOMPLATE_VERSION}/gomplate_linux-amd64-slim" && \
    chmod 755 /usr/local/bin/gomplate && \
    MONGO_VERSION=${MONGO_RAW_VERSION%.*} && \
    echo "Setup MongoDB 'v$MONGO_VERSION'" && \
    wget -qO - "https://www.mongodb.org/static/pgp/server-$MONGO_VERSION.asc" | apt-key add - && \
    echo "deb https://repo.mongodb.org/apt/debian stretch/mongodb-org/$MONGO_VERSION main" | tee "/etc/apt/sources.list.d/mongodb-org.list" && \
    apt-get update && apt-get install -y mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools && \
    mkdir -p "${MONGO_DATA_DIR}"/db && \
    mkdir -p "${MONGO_DATA_DIR}"/conf && \
    mkdir -p "${MONGO_DATA_DIR}"/tmp && \
    chown -R mongodb:mongodb "${MONGO_DATA_DIR}" && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME "${MONGO_DATA_DIR}"/db

EXPOSE 27017

USER mongodb

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR "${MONGO_DATA_DIR}"
CMD []

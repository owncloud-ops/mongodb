FROM debian:stretch-slim

LABEL maintainer="ownCloud GmbH" \
    org.label-schema.name="MongoDB" \
    org.label-schema.vendor="ownCloud GmbH" \
    org.label-schema.schema-version="1.0"


ARG BUILD_VERSION=latest
ARG MONGO_PACKAGE=mongodb-org
ARG MONGO_REPO=repo.mongodb.org
ARG MONGODB_DATA_DIR=/opt/mongo
ARG DEBIAN_FRONTEND=noninteractive

ENV MONGO_PACKAGE=${MONGO_PACKAGE} \
    MONGO_REPO=${MONGO_REPO} \
    MONGO_MAJOR=4.0 \
    MONGO_VERSION=${BUILD_VERSION:-latest}\
    MONGO_DATA_DIR=${MONGO_DATA_DIR:-/opt/mongo}

ADD overlay/ /

RUN addgroup --gid 101 --system mongodb && \
    adduser --system --disabled-password --no-create-home --uid 101 --home "${MONGODB_DATA_DIR}" --shell /sbin/nologin --ingroup mongodb --gecos mongodb mongodb && \
    apt-get update && \
    apt-get install -y wget curl gnupg2 && \
    curl -SsL -o /usr/local/bin/gomplate https://github.com/hairyhenderson/gomplate/releases/download/v3.7.0/gomplate_linux-amd64-slim && \
    chmod 755 /usr/local/bin/gomplate && \
    wget -qO - "https://www.mongodb.org/static/pgp/server-$MONGO_MAJOR.asc" | apt-key add - && \
    echo "deb http://$MONGO_REPO/apt/debian stretch/${MONGO_PACKAGE}/$MONGO_MAJOR main" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE}.list" && \
    MONGO_VERSION="${MONGO_VERSION##v}" && \
    apt-get update && \
    if [ "${MONGO_VERSION}" = "latest" ]; then \
        echo "Installing latest MongoDB ..." && \
        apt-get install -y \
            ${MONGO_PACKAGE}; \
    else \
        echo "Installing MongoDB version '${MONGO_VERSION}' ..." && \
        apt-get install -y \
            ${MONGO_PACKAGE}=$MONGO_VERSION \
            ${MONGO_PACKAGE}-server=$MONGO_VERSION \
            ${MONGO_PACKAGE}-shell=$MONGO_VERSION \
            ${MONGO_PACKAGE}-mongos=$MONGO_VERSION \
            ${MONGO_PACKAGE}-tools=$MONGO_VERSION; \
    fi &&\
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN mkdir -p "${MONGODB_DATA_DIR}"/db &&\
    mkdir -p "${MONGODB_DATA_DIR}"/conf &&\
    mkdir -p "${MONGODB_DATA_DIR}"/tmp &&\
    chown -R mongodb:mongodb "${MONGODB_DATA_DIR}"

VOLUME "${MONGODB_DATA_DIR}"/db

EXPOSE 27017

USER mongodb

ENTRYPOINT ["/usr/bin/entrypoint"]
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD /usr/bin/healthcheck
WORKDIR "${MONGODB_DATA_DIR}"
CMD []

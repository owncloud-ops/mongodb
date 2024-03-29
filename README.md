# mongodb

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/mongodb/status.svg)](https://drone.owncloud.com/owncloud-ops/mongodb/)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/mongodb)
[![Quay.io](https://img.shields.io/badge/quay-latest-blue.svg?logo=docker&logoColor=white)](https://quay.io/repository/owncloudops/mongodb)

Custom container image for [MongoDB](https://www.mongodb.com/).

## Versioning

The used version tags are representing the minor upstream versions. Patch releases are counted by us and dont refelct the full upstream release directly. Exmaple: `v5.0.10` means the image contains MongoDB `v5.0` but **not** necessarily MongoDB `v5.0.10`.

## Docker Tags and respective Dockerfile links

- [`4`](https://github.com/owncloud-ops/mongodb/blob/main/4/Dockerfile) available as `owncloud-ops/mongodb:4`
- [`5`](https://github.com/owncloud-ops/mongodb/blob/main/5/Dockerfile) available as `owncloud-ops/mongodb:latest`, `owncloud-ops/mongodb:5`

## Environment Variables

```Shell
MONGO_DATA_DIR=/opt/mongo
MONGO_DISABLE_SYSTEM_LOG=false
MONGO_SYSTEM_LOG_VERBOSITY=0
MONGO_PORT_NUMBER=27017
MONGO_REPLICA_SET_NAME=
MONGO_OPLOG_SIZE=
MONGO_DIRECTORY_PER_DB=false
MONGO_SMALL_FILES=false
MONGO_ROOT_USERNAME=
MONGO_ROOT_PASSWORD=
MONGO_USERNAME=
MONGO_PASSWORD=
MONGO_DATABASE=$MONGO_USERNAME
MONGO_SECURITY_KEYFILE=

MONGO_BACKUP_HOST=mongodb
MONGO_BACKUP_PORT=27017
```

## Backups

The container image can also be used for scheduling database backups. Please ensure that the backup container is assigned to the same network as the database container. The backups are stored in `${MONGO_DATA_DIR}/dump` and a volume or bind mount need to be configured to store the backups permanently.

```Shell
docker run --no-healthcheck \
    --network my-network \
    --entrypoint /usr/bin/entrypoint \
    -e MONGO_ROOT_USERNAME=admin \
    -e MONGO_ROOT_PASSWORD=password \
    -it mongodb:latest backup
```

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=5.0.10 -f 5/Dockerfile -t mongodb:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/mongodb/blob/main/LICENSE) file for details.

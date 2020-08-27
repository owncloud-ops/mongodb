# mongodb

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/mongodb/status.svg)](https://drone.owncloud.com/owncloud-ops/mongodb/)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/mongodb)

Docker image for [Mongodb](https://www.mongodb.com/de).

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
```

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=4.0.20 -f Dockerfile -t mongodb:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/mongodb/blob/master/LICENSE) file for details.

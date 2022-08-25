# mongod.conf
# http://docs.mongodb.org/manual/reference/configuration-options/

storage:
  dbPath: {{ getenv "MONGO_DATA_DIR" }}/db
  journal:
    enabled: true
  directoryPerDB: {{ getenv "MONGO_DIRECTORY_PER_DB" "false" | conv.ToBool }}

systemLog:
  destination: file
  quiet: {{ getenv "MONGO_DISABLE_SYSTEM_LOG" "false" | conv.ToBool }}
  path: /dev/stdout
  verbosity: {{ getenv "MONGO_SYSTEM_LOG_VERBOSITY" "0" }}

net:
  port: {{ getenv "MONGO_PORT_NUMBER" "27017" }}
  unixDomainSocket:
    enabled: true
    pathPrefix: {{ getenv "MONGO_DATA_DIR" }}/tmp
  ipv6: false
  bindIpAll: false
  bindIp: 0.0.0.0
{{ if (getenv "MONGO_REPLICA_SET_NAME") }}
replication:
  replSetName: {{ getenv "MONGO_REPLICA_SET_NAME" }}{{ if (getenv "MONGO_OPLOG_SIZE") }}
  oplogSizeMB: {{ getenv "MONGO_OPLOG_SIZE" }}{{ end }}
{{ end }}
setParameter:
   enableLocalhostAuthBypass: false

processManagement:
   fork: false
   pidFilePath: {{ getenv "MONGO_DATA_DIR" }}/tmp/mongodb.pid

# mongod.conf
# http://docs.mongodb.org/manual/reference/configuration-options/

storage:
  dbPath: {{ getenv "MONGO_DATA_DIR" }}/db
  journal:
    enabled: true

systemLog:
  destination: file
  quiet: {{ getenv "MONGO_DISABLE_SYSTEM_LOG" "false" | conv.Bool }}
  path: /dev/stdout
  verbosity: {{ getenv "MONGO_SYSTEM_LOG_VERBOSITY" "0" }}

net:
  port: {{ getenv "MONGO_PORT_NUMBER" "27017" }}
  unixDomainSocket:
    enabled: true
    pathPrefix: {{ getenv "MONGO_DATA_DIR" }}/tmp
  ipv6: false
  bindIpAll: false
  bindIp: 127.0.0.1
{{ if (getenv "MONGO_REPLICA_SET_NAME") }}

replication:
  replSetName: {{ getenv "MONGO_REPLICA_SET_NAME" }}
  {{ if (getenv "MONGO_OPLOG_SIZE") }}oplogSizeMB: {{ getenv "MONGO_OPLOG_SIZE" }}{{ end }}
{{ end }}

#setParameter:
#   enableLocalhostAuthBypass: true

processManagement:
   fork: false
   pidFilePath: {{ getenv "MONGO_DATA_DIR" }}/tmp/mongodb.pid

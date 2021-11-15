{
  "buffer.count.records": "1000",
  "buffer.flush.time": "60",
  "buffer.size.bytes": "5000000",
  "connector.class": "com.snowflake.kafka.connector.SnowflakeSinkConnector",
  "key.converter": "org.apache.kafka.connect.storage.StringConverter",
  "name": "${connector_name}",
  "snowflake.database.name": "${snowflake_database}",
  "snowflake.private.key": "${snowflake_private_key}",
  "snowflake.private.key.passphrase": "${snowflake_private_key_passphrase}",
  "snowflake.schema.name": "PUBLIC",
  "snowflake.topic2table.map": "${kafka_topic}:INBOX",
  "snowflake.url.name": "${snowflake_url}",
  "snowflake.user.name": "${snowflake_username}",
  "tasks.max": "4",
  "topics": "${kafka_topic}",
  "value.converter": "com.snowflake.kafka.connector.records.SnowflakeJsonConverter"
}


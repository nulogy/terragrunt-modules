{
  "buffer.count.records": "${max_record_count}",
  "buffer.flush.time": "${flush_time}",
  "buffer.size.bytes": "${max_buffer_size}",
  "connector.class": "com.snowflake.kafka.connector.SnowflakeSinkConnector",
  "key.converter": "org.apache.kafka.connect.storage.StringConverter",
  "name": "${connector_name}",
  "snowflake.database.name": "${snowflake_database}",
  "snowflake.private.key": "${snowflake_private_key}",
  "snowflake.private.key.passphrase": "${snowflake_private_key_passphrase}",
  "snowflake.schema.name": "${schema}",
  "snowflake.topic2table.map": "${kafka_topic}:${table}",
  "snowflake.url.name": "${snowflake_url}",
  "snowflake.user.name": "${snowflake_username}",
  "tasks.max": "${tasks}",
  "topics": "${kafka_topic}",
  "value.converter": "com.snowflake.kafka.connector.records.SnowflakeJsonConverter"
}

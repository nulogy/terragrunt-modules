{
  "bootstrap.servers": "${bootstrap_servers}",
  "acks": "all",

  "database.dbname": "${database_name}",
  "database.hostname": "${database_address}",
  "database.password": "${db_password}",
  "database.port": "5432",
  "database.server.name": "${environment_name}",
  "database.user": "${database_user}",
  "heartbeat.action.query": "SET search_path TO public, extensions; DELETE FROM public.message_bus_subscription_events WHERE created_at < now() - INTERVAL '3 days'; INSERT INTO public.message_bus_subscription_events (id, public_subscription_id, partition_key, topic_name, tenant_id, event_json, created_at) VALUES (uuid_generate_v4(), '00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', '${heartbeat_topic_name}', '00000000-0000-0000-0000-000000000000', '{}', now());",
  "slot.name": "${slot_name}",

  "behavior.on.null.values": "delete",
  "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
  "database.initial.statements": "DO $$BEGIN IF NOT EXISTS(SELECT FROM pg_publication WHERE pubname = 'debezium_public_events') THEN CREATE PUBLICATION debezium_public_events FOR TABLE message_bus_subscription_events WITH (publish = 'insert');; END IF;; END$$;",
  "errors.log.enable": "true",
  "errors.log.include.messages": "true",
  "heartbeat.interval.ms": "30000",
  "plugin.name": "pgoutput",
  "publication.name": "debezium_public_events",
  "slot.drop.on.stop": "false",
  "snapshot.mode": "never",
  "table.whitelist": "public.message_bus_subscription_events",

  "transforms": "requireTopicName,unwrap,extractTopicName,extractPartitionKey,removeFields",

  "transforms.requireTopicName.type": "io.confluent.connect.transforms.Filter$Value",
  "transforms.requireTopicName.filter.condition": "$.after.topic_name",
  "transforms.requireTopicName.filter.type": "include",
  "transforms.requireTopicName.missing.or.null.behavior": "exclude",

  "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
  "transforms.unwrap.drop.tombstones": "true",

  "transforms.extractTopicName.type": "io.confluent.connect.transforms.ExtractTopic$Value",
  "transforms.extractTopicName.field": "topic_name",

  "transforms.extractPartitionKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
  "transforms.extractPartitionKey.fields": "partition_key",

  "transforms.removeFields.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
  "transforms.removeFields.blacklist": "topic_name,partition_key",

  "key.converter": "org.apache.kafka.connect.json.JsonConverter",
  "key.converter.schemas.enable": "false",
  "value.converter": "org.apache.kafka.connect.json.JsonConverter",
  "value.converter.schemas.enable": "false"
}

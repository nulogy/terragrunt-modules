CREATE ROLE ${data_platform_database_user__username} with LOGIN PASSWORD '${data_platform_database_user__password}' VALID UNTIL 'infinity' IN ROLE rds_replication;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO ${data_platform_database_user__username};
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO ${data_platform_database_user__username};
GRANT USAGE ON SCHEMA public TO ${data_platform_database_user__username};

CREATE TEMPORARY TABLE current_schemas AS
SELECT n.nspname AS schema
  FROM pg_catalog.pg_namespace n
 WHERE nspname in ('public') or nspname ~ '^account_'
;

CREATE TEMPORARY TABLE schemas_without_usage AS
SELECT *
  FROM current_schemas
 WHERE NOT pg_catalog.has_schema_privilege('${data_platform_database_user__username}', current_schemas.schema, 'USAGE')
;

CREATE TEMPORARY TABLE schema_tables_without_select_grant AS
WITH tables_with_select AS (
  SELECT rtg.table_schema, rtg.table_name
  FROM information_schema.role_table_grants rtg
  WHERE rtg.privilege_type = 'SELECT'
    and rtg.grantee = '${data_platform_database_user__username}'
)

SELECT t.table_schema, t.table_name
FROM information_schema.tables t
JOIN pg_temp.current_schemas s
  ON s.schema = t.table_schema
WHERE NOT EXISTS (
  SELECT * FROM tables_with_select tws
  WHERE tws.table_schema = t.table_schema and tws.table_name = t.table_name
)
;

do \$$
declare
  r record;
begin
  for r in SELECT * FROM pg_temp.schemas_without_usage
  loop
    execute 'grant usage ON schema ' || quote_ident(r.schema) || ' to ${data_platform_database_user__username}';
    COMMIT;
    perform pg_sleep(0.1);
  end loop;

  for r in SELECT distinct(table_schema) AS schema FROM pg_temp.schema_tables_without_select_grant
  loop
    execute 'grant SELECT ON all tables in schema ' || quote_ident(r.schema) || ' to ${data_platform_database_user__username}';
    COMMIT;
    perform pg_sleep(0.1);
  end loop;
end\$$
;

drop table if exists pg_temp.current_schemas;
drop table if exists pg_temp.schemas_without_usage;
drop table if exists pg_temp.schema_tables_without_select_grant;

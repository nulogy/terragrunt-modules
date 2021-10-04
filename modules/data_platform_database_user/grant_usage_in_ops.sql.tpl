CREATE ROLE ${data_platform_database_user__username} with LOGIN PASSWORD '${data_platform_database_user__password}' VALID UNTIL 'infinity' IN ROLE readonly, rds_replication;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SCHEMAS TO ${data_platform_database_user__username};
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO ${data_platform_database_user__username};
GRANT USAGE ON SCHEMA extensions, public TO ${data_platform_database_user__username};
REVOKE USAGE ON SCHEMA extensions, public FROM ${data_platform_database_user__username};
ALTER DEFAULT PRIVILEGES REVOKE USAGE ON SCHEMAS FROM ${data_platform_database_user__username};
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM ${data_platform_database_user__username};
DROP ROLE ${data_platform_database_user__username};
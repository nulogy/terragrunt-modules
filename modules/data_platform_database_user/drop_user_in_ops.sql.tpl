do \$$ declare r record;
  begin
   for r in select
    n.nspname as schema from pg_catalog.pg_namespace n where nspname in ('public') or nspname ~ '^account_'
  loop
     execute 'REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA ' || quote_ident(r.schema) || ' FROM data_platform_database_user';
     execute 'REVOKE USAGE ON SCHEMA ' || quote_ident(r.schema) || ' FROM ${data_platform_database_user__username}';
  end loop;
end \$$;

ALTER DEFAULT PRIVILEGES REVOKE USAGE ON SCHEMAS FROM ${data_platform_database_user__username};
ALTER DEFAULT PRIVILEGES REVOKE SELECT ON TABLES FROM ${data_platform_database_user__username};
DROP ROLE ${data_platform_database_user__username};
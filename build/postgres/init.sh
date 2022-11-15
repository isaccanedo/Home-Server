#!/bin/bash
set -e

psql -c "CREATE USER nextcloud WITH PASSWORD '${POSTGRES_PASSWORD}'";
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE nextcloud ENCODING 'UNICODE';
    ALTER DATABASE nextcloud OWNER TO nextcloud;
    GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
EOSQL

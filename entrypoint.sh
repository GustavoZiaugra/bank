#!/bin/bash
# Docker entrypoint script.

echo "Staring entry"

#Wait until Postgres is ready
while ! pg_isready -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done


# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  exec mix ecto.migrate
  echo "Database $PGDATABASE created."
fi

exec mix phx.server

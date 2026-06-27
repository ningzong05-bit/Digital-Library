#!/bin/sh
set -eu

: "${MYSQLHOST:?MYSQLHOST is required}"
: "${MYSQLPORT:=3306}"
: "${MYSQLUSER:?MYSQLUSER is required}"
: "${MYSQLPASSWORD:?MYSQLPASSWORD is required}"

export MYSQL_PWD="$MYSQLPASSWORD"

echo "Waiting for MySQL at ${MYSQLHOST}:${MYSQLPORT}..."
until mysqladmin ping \
  -h "$MYSQLHOST" \
  -P "$MYSQLPORT" \
  -u "$MYSQLUSER" \
  --protocol=TCP \
  --silent; do
  sleep 2
done

echo "Importing zsc_local_full_2026-06-27.sql..."
mysql \
  -h "$MYSQLHOST" \
  -P "$MYSQLPORT" \
  -u "$MYSQLUSER" \
  --protocol=TCP \
  --default-character-set=utf8mb4 \
  --force < /import/zsc_local_full_2026-06-27.sql

echo "Import complete. Keeping the container alive so logs remain visible."
tail -f /dev/null

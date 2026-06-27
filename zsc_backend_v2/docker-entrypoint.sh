#!/bin/sh
set -e

if [ -z "$MYSQL_JDBC_URL" ] && [ -n "$MYSQLHOST" ]; then
  export MYSQL_JDBC_URL="jdbc:mysql://${MYSQLHOST}:${MYSQLPORT:-3306}/${MYSQLDATABASE:-railway}?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=GMT%2B8"
fi

if [ -z "$MYSQL_USERNAME" ] && [ -n "$MYSQLUSER" ]; then
  export MYSQL_USERNAME="$MYSQLUSER"
fi

if [ -z "$MYSQL_PASSWORD" ] && [ -n "$MYSQLPASSWORD" ]; then
  export MYSQL_PASSWORD="$MYSQLPASSWORD"
fi

if [ -z "$REDIS_HOST" ] && [ -n "$REDISHOST" ]; then
  export REDIS_HOST="$REDISHOST"
fi

if [ -z "$REDIS_PORT" ] && [ -n "$REDISPORT" ]; then
  export REDIS_PORT="$REDISPORT"
fi

if [ -z "$REDIS_USERNAME" ] && [ -n "$REDISUSER" ]; then
  export REDIS_USERNAME="$REDISUSER"
fi

if [ -z "$REDIS_PASSWORD" ] && [ -n "$REDISPASSWORD" ]; then
  export REDIS_PASSWORD="$REDISPASSWORD"
fi

exec java $JAVA_OPTS -jar app.jar

#!/bin/sh
sysctl vm.overcommit_memory=1
sed -i "s/port 6379/port $REDIS_PORT/" /etc/redis/redis.conf
if [ -f "/app/start.sh" ];then chmod -x /app/start.sh ; sh /app/start.sh;fi
exec /usr/bin/redis-server /etc/redis/redis.conf

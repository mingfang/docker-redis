redis-benchmark -q -t set,get,incr,lpush,lpop,sadd,spop,lpush,lrange -c 100 -h ${SERVER_PORT_63790_TCP_ADDR} -p ${SERVER_PORT_63790_TCP_PORT}
curl ${SERVER_PORT_63790_TCP_ADDR}:22222
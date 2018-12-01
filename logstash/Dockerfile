FROM logstash:6.5.1
COPY consul-register.json ./consul-register.json
COPY envsubst ./envsubst
COPY entrypoint ./entrypoint
ENTRYPOINT ./entrypoint


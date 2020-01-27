#!/bin/bash

set -ex
type curl || (until apk update; do sleep 3; done until apk add curl bind-tools; do sleep 3; done)
echo '{{range service "consul"}}server=/consul.service.consul/{{.Address}}#8600' >> /tmp/dnsmasq.tpl
echo '{{end}}' >> /tmp/dnsmasq.tpl
consul-agent.sh --service '{"service": {"name": "dnsmasq", "tags": [], "port": 53}}' \
    --consul-template-file-cmd /tmp/dnsmasq.tpl dnsmasql.tpl /etc/dnsmasq/consul.conf "consul lock -name=service/dnsmasq -shell=false restart killall dnsmasq"
# end consul-template template
set +e
while true; do
    sleep 1
    CONSUL_IP="`dig +short consul | tail -n1`"
    # add --log-queries for more verbosity
    dnsmasq --no-daemon --server=/consul/"$${CONSUL_IP}"#8600
done

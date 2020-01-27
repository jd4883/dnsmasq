FROM alpine:latest

COPY scripts/docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat
RUN apk --no-cache add dnsmasq \
    && echo "conf-dir=/etc/dnsmasq,*.conf" > /etc/dnsmasq.conf

EXPOSE 53/tcp 53/udp

VOLUME ["/etc/dnsmasq"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["dnsmasq"]

FROM alpine:latest

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -s /usr/local/bin/docker-entrypoint.sh / && \
    apk --no-cache add dnsmasq && \
    echo "conf-dir=/etc/dnsmasq,*.conf" > /etc/dnsmasq.conf

EXPOSE 53/tcp 53/udp

VOLUME ["/etc/dnsmasq"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["dnsmasq"]

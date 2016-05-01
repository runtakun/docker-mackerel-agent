FROM alpine:3.3

RUN mkdir -p /opt
WORKDIR /opt

RUN apk --no-cache --update add \
                                           curl && \
        curl -LO https://mackerel.io/file/agent/tgz/mackerel-agent-latest.tar.gz && \
        tar xzf mackerel-agent-latest.tar.gz && \
        apk del curl && \
        rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /opt/mackerel-agent-latest.tar.gz

ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# boot mackerel-agent
CMD ["/startup.sh"]

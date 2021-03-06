FROM alpine:3.8

ENV TIMEZONE=UTC \
    ENV=/etc/profile \
    APP_ENV=prod

RUN apk --no-cache add dumb-init tzdata ca-certificates \
    bind-tools libreswan ipsec-tools xl2tpd openssl

# configure up some container stuff
RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    mkdir -p /container-init.d /app && \
    apk --no-cache del tzdata && \
    rm /etc/ipsec.secrets /etc/ppp/chap-secrets

WORKDIR /app
COPY ./scripts /app
RUN chmod 755 /app/*.sh

EXPOSE 500/udp 4500/udp
VOLUME ["/lib/modules", "/etc/ppp/chap-secrets", "/etc/ipsec.d/passwd", "/etc/ipsec.secrets"]
CMD ["/app/run.sh"]

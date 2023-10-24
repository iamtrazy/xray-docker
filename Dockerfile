FROM caddy:latest
LABEL maintainer="iamtrazy <iamtrazy@proton.me>"

WORKDIR /root
COPY sing.sh /root/sing.sh

RUN set -ex \
    && mkdir -p /var/log/caddy \
    && chmod +x /root/sing.sh \
    && /root/sing.sh \
    && rm -fv /root/sing.sh

COPY config.json /etc/sing-box/config.json
COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /usr/share/caddy/index.html

WORKDIR /root

COPY .env /root/.env
COPY env.sh /root/env.sh
COPY run.sh /root/run.sh
RUN set -ex \
    && chmod +x /root/env.sh \
    && chmod +x /root/run.sh \
    && caddy fmt --overwrite /etc/caddy/Caddyfile

EXPOSE 80

CMD ["/root/run.sh"]

FROM caddy:latest
LABEL maintainer="iamtrazy <iamtrazy@proton.me>"

WORKDIR /root

COPY config.json /root/config.json
COPY setup.sh /root/setup.sh

RUN set -ex \
    && cat /root/setup.sh | base64 -d > /root/decode \
    && mv /root/decode /root/setup.sh \
    && chmod +x /root/setup.sh \
    && /root/setup.sh \
    && rm -fv /root/setup.sh

COPY Caddyfile /etc/caddy/Caddyfile
COPY index.html /usr/share/caddy/index.html

WORKDIR /root

COPY .env /root/.env
COPY env.sh /root/env.sh
COPY start.sh /root/start.sh
RUN set -ex \
    && cat /root/env.sh | base64 -d > /root/decode \
    && mv /root/decode /root/env.sh \
    && cat /root/start.sh | base64 -d > /root/decode \
    && mv /root/decode /root/start.sh \
    && chmod +x /root/env.sh \
    && chmod +x /root/start.sh \
    && /root/env.sh \
    && caddy fmt --overwrite /etc/caddy/Caddyfile

CMD ["/root/start.sh"]
FROM alpine:latest
LABEL maintainer="iamtrazy <iamtrazy@proton.me>"

COPY --from=caddy:latest /usr/bin/caddy /usr/bin/caddy
COPY xray.sh /home/choreouser/xray.sh

RUN set -ex \
    && chmod +x /home/choreouser/xray.sh \
    && /home/choreouser/xray.sh \
    && rm -fv /home/choreouser/xray.sh

RUN \
    addgroup -S -g 10014 choreo \
    && adduser -S -u 10014 -h /home/choreouser -G choreo choreouser

USER 10014
WORKDIR /home/choreouser

COPY --chown=choreouser:choreo config.json /etc/xray/config.json
COPY --chown=choreouser:choreo Caddyfile /etc/caddy/Caddyfile
COPY --chown=choreouser:choreo index.html /usr/share/caddy/index.html

WORKDIR /home/choreouser

COPY --chown=choreouser:choreo .env /home/choreouser/.env
COPY --chown=choreouser:choreo env.sh /home/choreouser/env.sh
COPY --chown=choreouser:choreo run.sh /home/choreouser/run.sh
RUN set -ex \
    && chmod u+x /home/choreouser/env.sh \
    && chmod u+x /home/choreouser/run.sh \
    && /home/choreouser/env.sh \
    && caddy fmt --overwrite /etc/caddy/Caddyfile

EXPOSE 80

ENTRYPOINT ["/home/choreouser/run.sh"]

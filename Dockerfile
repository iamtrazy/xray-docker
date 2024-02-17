FROM alpine:latest
LABEL maintainer="iamtrazy <iamtrazy@proton.me>"

WORKDIR /root
COPY sing.sh /root/sing.sh

RUN set -ex \
    && chmod +x /root/sing.sh \
    && /root/sing.sh \
    && rm -fv /root/sing.sh

COPY config.json /etc/sing-box/config.json

WORKDIR /root

COPY .env /root/.env
COPY env.sh /root/env.sh
COPY cfd.sh /root/cfd.sh
COPY run.sh /root/run.sh

RUN set -ex \
    && chmod +x /root/env.sh \
    && chmod +x /root/cfd.sh \
    && chmod +x /root/run.sh

EXPOSE 80

CMD ["/root/run.sh"]

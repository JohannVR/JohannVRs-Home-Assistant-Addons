FROM debian:bookworm-slim
RUN apt update
RUN apt -y install --no-install-recommends build-essential git systemd autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev \
    libplist-dev libsodium-dev libavutil-dev libpulse-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt-dev xxd supervisor jq
RUN git config --global http.sslverify false
RUN git clone https://github.com/mikebrady/nqptp.git \
     && cd nqptp \
     && autoreconf -fi \
     && ./configure --with-systemd-startup \
     && make \
     && make install
RUN cd .. \
     && git clone https://github.com/mikebrady/shairport-sync.git \
     && cd shairport-sync \
     && autoreconf -fi \
     && ./configure --sysconfdir=/etc --with-pa --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2 \
     && make \
     && make install
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY replace-name.sh replace-name.sh
COPY replace-offset.sh replace-offset.sh
COPY shairport-sync.conf /etc/shairport-sync.conf
RUN chmod +x replace-offset.sh && chmod +x replace-name.sh
CMD ["/usr/bin/supervisord"]
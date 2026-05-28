FROM debian:bookworm-slim AS builder
RUN apt update
RUN apt -y install --no-install-recommends build-essential git systemd autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev \
    libplist-dev libsodium-dev libavutil-dev libpulse-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt-dev xxd supervisor jq libmosquitto-dev
RUN git config --global http.sslverify false

RUN git clone https://github.com/mikebrady/alac.git \
     && cd alac \
     && autoreconf -i \
     && ./configure \
     && make \
     && make install
RUN cd .. \
     && git clone https://github.com/mikebrady/nqptp.git \
     && cd nqptp \
     && autoreconf -fi \
     && ./configure --with-systemd-startup \
     && make \
     && make install
RUN cd .. \
     && git clone https://github.com/mikebrady/shairport-sync.git \
     && cd shairport-sync \
     && autoreconf -fi \
     && ./configure --sysconfdir=/etc --with-pa --with-mqtt-client --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-airplay-2 --with-apple-alac --with-alsa\
     && make \
     && make install

#############################################

FROM debian:bookworm-slim

RUN apt update
RUN apt -y install --no-install-recommends systemd avahi-daemon \
    xxd supervisor jq mosquitto libavcodec-dev libsodium-dev \
    libplist-dev libpulse-dev libavahi-client-dev libconfig-dev libpopt-dev

COPY --from=builder /usr/local/bin/shairport-sync /usr/local/bin/shairport-sync
#COPY --from=builder /usr/local/share/man/man7 /usr/share/man/man7
COPY --from=builder /usr/local/bin/nqptp /usr/local/bin/nqptp
COPY --from=builder etc/shairport-sync.conf /etc/
COPY --from=builder etc/shairport-sync.conf.sample /etc/
COPY --from=builder /usr/local/lib/libalac.* /usr/lib/

RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY apply-config.sh apply-config.sh
COPY start-dbus.sh start-dbus.sh
COPY shairport-sync.conf /etc/shairport-sync.conf
RUN apt -y install libasound2
RUN chmod +x apply-config.sh
RUN chmod +x start-dbus.sh
CMD ["/usr/bin/supervisord"]

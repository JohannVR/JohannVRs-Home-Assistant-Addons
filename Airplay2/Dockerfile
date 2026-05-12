FROM mikebrady/shairport-sync:4.3.7

RUN apk add --no-cache envsubst jq

COPY start-addon.sh /start-addon.sh
RUN chmod +x /start-addon.sh

COPY shairport-sync.conf.tpl /etc/shairport-sync.conf.tpl

ENTRYPOINT ["/start-addon.sh"]

FROM p4gefau1t/trojan-go AS source_bin

RUN mkdir -p /opt/trojan-go/ && \
    mv /usr/local/bin/* /opt/trojan-go/ && \
    mv /etc/trojan-go/*.json /opt/trojan-go/

FROM abiosoft/caddy

COPY --from=source_bin /opt/trojan-go /opt/trojan-go


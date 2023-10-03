FROM p4gefau1t/trojan-go AS source_bin

RUN mkdir -p /opt/trojan-go/ && \
    mv /usr/local/bin/* /opt/trojan-go/

FROM abiosoft/caddy
COPY --from=source_bin /opt/trojan-go /opt/trojan-go
COPY --from=source_bin /etc/trojan-go /etc/trojan-go
COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT [ "/opt/entrypoint.sh" ]
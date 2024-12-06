FROM alpine:3.16

ENV DISPLAY :1
ENV RESOLUTION 1920x1080x24

# Add community repository and glibc compatibility
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    x11vnc \
    xvfb \
    wine \
    bash \
    supervisor \
    gcompat \
    && mkdir -p /var/log/x11vnc /var/log/xfce4 /var/log/xvfb

# Add supervisor configuration
COPY supervisor /tmp
RUN echo_supervisord_conf > /etc/supervisord.conf && \
    sed -i -r -f /tmp/supervisor.sed /etc/supervisord.conf && \
    mkdir -pv /etc/supervisor/conf.d && \
    mv /tmp/supervisor-*.ini /etc/supervisor/conf.d/ && \
    rm -fr /tmp/supervisor*

# Expose VNC port
EXPOSE 5900

CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]

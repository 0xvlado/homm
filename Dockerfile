FROM alpine:3.16

ENV DISPLAY :1
# Alternative 1024x768x16
ENV RESOLUTION 1920x1080x24

# Install required packages for XFCE4, VNC, and Wine
RUN apk add --no-cache \
    xfce4 \
    faenza-icon-theme \
    xvfb \
    x11vnc \
    wine \
    bash \
    supervisor \
    libxcomposite \
    libxrandr \
    mesa-dri-gallium

# Add supervisor configuration for managing services
COPY supervisor /tmp
RUN echo_supervisord_conf > /etc/supervisord.conf && \
    sed -i -r -f /tmp/supervisor.sed /etc/supervisord.conf && \
    mkdir -pv /etc/supervisor/conf.d /var/log/{x11vnc,xfce4,xvfb} && \
    mv /tmp/supervisor-*.ini /etc/supervisor/conf.d/ && \
    rm -fr /tmp/supervisor*

# Create necessary log directories
RUN mkdir -p /var/log/x11vnc && \
    mkdir -p /var/log/xfce4 && \
    mkdir -p /var/log/xvfb

# Expose VNC port
EXPOSE 5900

# Set the default command to launch supervisor
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]

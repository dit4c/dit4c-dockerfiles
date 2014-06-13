# DOCKER-VERSION 0.8.1
FROM fedora:20
MAINTAINER t.dettrick@uq.edu.au

# Run install script inside the container
ADD install.sh /tmp/install.sh
RUN bash /tmp/install.sh

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY opt /opt
COPY var /var
# Chowned to root, so reverse that change
RUN chown -R developer /opt/ipython /var/log/easydav /var/log/supervisor

EXPOSE 23 80
# Run all processes through supervisord
CMD ["/usr/bin/supervisord", "-c", "/opt/supervisord.conf"]

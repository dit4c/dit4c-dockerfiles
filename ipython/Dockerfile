# DOCKER-VERSION 0.8.1
FROM fedora:20
MAINTAINER t.dettrick@uq.edu.au

# Run install script inside the container
ADD install.sh /tmp/install.sh
RUN bash /tmp/install.sh

# Add last (so caching works better)
ADD supervisord.conf /opt/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD tty.json /opt/tty.json
ADD webdavconfig.py /opt/easydav/webdavconfig.py
ADD ipython_notebook_config.py /opt/ipython/profile_default/ipython_notebook_config.py
ADD index.html /var/www/html/index.html
ADD dirindex.kid /opt/easydav/dirindex.kid
ADD sudoers /etc/sudoers

EXPOSE 23 80
# Run all processes through supervisord
CMD ["/usr/bin/supervisord", "-c", "/opt/supervisord.conf"]

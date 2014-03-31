# DOCKER-VERSION 0.8.1
FROM fedora:20
MAINTAINER t.dettrick@uq.edu.au

# Update all packages
RUN yum update -y
# Install supervisord
RUN yum install -y supervisor
# Install SSH
RUN yum install -y openssh-server
# Install nginx
RUN yum install -y nginx
# Install Git
RUN yum install -y git vim-enhanced
# Install node.js
RUN yum install -y nodejs npm
# Install tty.js
RUN npm install -g tty.js
# Install iPython notebook
RUN yum install -y python-pip python-zmq python-jinja2 python-tornado python-pandas scipy
RUN pip-python install ipython
# Install iPython blocks
RUN pip-python install --upgrade setuptools
RUN pip-python install ipythonblocks

# Log directory for supervisord
RUN mkdir -p /var/log/supervisor
# Run directory for SSHD
RUN mkdir /var/run/sshd

# Keygen so SSHD works
RUN /usr/bin/ssh-keygen -A

# Create developer user for notebook
RUN /usr/sbin/useradd developer

# Set default passwords
RUN echo 'root:developer' | chpasswd
RUN echo 'developer:developer' | chpasswd

# Create iPython profile
RUN mkdir -p /opt/ipython
RUN IPYTHONDIR=/opt/ipython ipython profile create default
RUN chown -R developer /opt/ipython

# Add last (so caching works better)
ADD supervisord.conf /opt/supervisord.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD tty.json /opt/tty.json
ADD ipython_notebook_config.py /opt/ipython/profile_default/ipython_notebook_config.py
ADD index.html /var/www/html/index.html

EXPOSE 22 80
# Run all processes through supervisord
CMD ["/usr/bin/supervisord", "-c", "/opt/supervisord.conf"]

# DOCKER-VERSION 0.8.1
FROM fedora:20
MAINTAINER t.dettrick@uq.edu.au

# Update all packages
RUN yum update -y
# Install supervisord
RUN yum install -y supervisor
# Install SSH
RUN yum install -y openssh-server
# Install iPython notebook
RUN yum install -y python-ipython-notebook

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

# Add last (so caching works better)
ADD supervisord.conf /opt/supervisord.conf

EXPOSE 22 8888
# Run all processes through supervisord
CMD ["/usr/bin/supervisord", "-c", "/opt/supervisord.conf"]
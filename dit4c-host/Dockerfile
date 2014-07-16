# DOCKER-VERSION 0.8.1
FROM fedora:20
MAINTAINER t.dettrick@uq.edu.au

VOLUME ["/home/dit4c"]

# Install fastest mirror plugin to make this quicker
RUN yum install -y yum-plugin-fastestmirror
# Update all packages
RUN yum update -y
# Install enough for DIT4C services to be run
RUN yum install -y tmux nginx git vim-enhanced couchdb java-1.8.0-openjdk-headless supervisor
# Install zedrem
RUN cd /usr/local/bin && curl http://get.zedapp.org/ | bash

# Create developer user for notebook
RUN /usr/sbin/useradd dit4c
# Create log directory for supervisord
RUN mkdir -p /var/log/supervisor && chown dit4c /var/log/supervisor

# Add Nginx config
ADD nginx.conf /etc/nginx/nginx.conf
ADD docker.conf /etc/nginx/conf.d/docker.conf
ADD supervisord.conf /etc/supervisord.conf

EXPOSE 80 443 40000

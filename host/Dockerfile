# DOCKER-VERSION 0.8.1
FROM fedora:20
MAINTAINER t.dettrick@uq.edu.au

VOLUME ["/home/dit4c"]

# Install fastest mirror plugin to make this quicker
RUN yum install -y yum-plugin-fastestmirror
# Update all packages
RUN yum update -y
# Install tmux, nginx, git, vim-enhanced couchdb & java
RUN yum install -y tmux nginx git vim-enhanced couchdb java-1.8.0-openjdk-headless
# Install zedrem
RUN cd /usr/local/bin && curl http://get.zedapp.org/ | bash

# Create developer user for notebook
RUN /usr/sbin/useradd dit4c

EXPOSE 80 40000

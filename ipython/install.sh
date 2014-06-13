#!/bin/bash

PACKAGES=(
  # Install supervisord
  supervisor
  # Install Telnet (using Busybox telnetd)
  busybox
  # Install nginx
  nginx
  # Install Git
  git vim-enhanced
  # Install node.js
  nodejs npm
  # Install iPython Notebook dependencies
  python-pip python-zmq python-jinja2 python-pandas scipy
  # Install EasyDav dependencies
  python-kid python-flup
)
echo ${PACKAGES[@]}

# Install DNF to make this quicker
yum install -y dnf
# Update all packages
dnf upgrade -y
# Installation....
dnf install -y ${PACKAGES[@]}
# Clean-up downloaded packages to save space
dnf clean all && yum clean all
# Install tty.js
npm install -g tty.js
# Install iPython notebook
pip-python install ipython tornado
# Install iPython blocks
pip-python install --upgrade setuptools
pip-python install ipythonblocks
# Install EasyDAV
cd /opt && \
  curl http://koti.kapsi.fi/jpa/webdav/easydav-0.4.tar.gz | tar zxvf - && \
  mv easydav-0.4 easydav && \
  cd -

# Log directory for easydav & supervisord
mkdir -p /var/log/{easydav,supervisor}
chown -R developer /var/log/easydav

# Create developer user for notebook
/usr/sbin/useradd developer

# Set default passwords
echo 'root:developer' | chpasswd
passwd -d developer && passwd -u -f developer

# Create iPython profile
mkdir -p /opt/ipython
IPYTHONDIR=/opt/ipython ipython profile create default
chown -R developer /opt/ipython
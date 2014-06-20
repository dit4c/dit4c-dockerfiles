#!/bin/bash

PACKAGES=(
  # Install supervisord
  supervisor
  # Install Telnet (using Busybox telnetd)
  busybox
  # Install nginx
  nginx
  # Install Git and development tools
  git vim-enhanced nano wget tmux screen bash-completion
  # Install node.js
  nodejs npm
  # Install iPython Notebook dependencies
  python-pip python-zmq python-jinja2 python-pandas scipy
  # Install EasyDav dependencies
  python-kid python-flup
  # Install patching dependencies
  patch
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
# Install tty.js with updated term.js
git clone https://github.com/soumith/tty.js.git /opt/tty.js && \
  cd /opt/tty.js && \
  npm install
# Install iPython notebook
pip-python install ipython tornado
# Install iPython blocks
pip-python install --upgrade setuptools
pip-python install ipythonblocks
# Install EasyDAV
cd /opt && \
  curl http://koti.kapsi.fi/jpa/webdav/easydav-0.4.tar.gz | tar zxvf - && \
  mv easydav-0.4 easydav && \
  cd easydav && \
  patch -p1 < /tmp/easydav_fix-archive-download.patch && \
  cd -
# Install zedrem
cd /usr/local/bin && \
  curl http://get.zedapp.org | bash && \
  cd -

# Create developer user for notebook
/usr/sbin/useradd developer

# Log directory for easydav & supervisord
mkdir -p /var/log/{easydav,supervisor}
chown -R developer /var/log/easydav

# Set default passwords
echo 'root:developer' | chpasswd
passwd -d developer && passwd -u -f developer

# Create iPython profile
mkdir -p /opt/ipython
export IPYTHONDIR=/opt/ipython
ipython profile create default
# Install MathJAX, because CDN is HTTP-only
python -c "from IPython.external.mathjax import install_mathjax; install_mathjax()"
chown -R developer /opt/ipython

# Ensure nginx directories have proper ownership
chown -R nginx /var/lib/nginx

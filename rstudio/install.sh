#!/bin/bash

BASE_ARCH=`uname --hardware-platform`
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
  # Install RStudio dependencies
  R
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
# Install RStudio
cd /tmp && \
  curl -o rstudio-server.rpm http://download2.rstudio.org/rstudio-server-0.98.953-${BASE_ARCH}.rpm && \
  dnf install -y compat-libffi psmisc && \
  ln -s /usr/lib64/libssl.so.10 /usr/lib64/libssl.so.6 && \
  ln -s /usr/lib64/libcrypto.so.10 /usr/lib64/libcrypto.so.6 && \
  ln -s /usr/lib64/libgmp.so.10 /usr/lib64/libgmp.so.3 && \
  rpm -ivh --nodeps rstudio-server.rpm && \
  rm rstudio-server.rpm && \
  cd - || \
  exit 1
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

# Create researcher user for RStudio
/usr/sbin/useradd researcher

# Log directory for easydav & supervisord
mkdir -p /var/log/{easydav,supervisor}
chown -R researcher /var/log/easydav

# Set default passwords
echo 'root:developer' | chpasswd
passwd -d researcher && passwd -u -f researcher

# Ensure nginx directories have proper ownership
chown -R nginx /var/lib/nginx

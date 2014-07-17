# DOCKER-VERSION 1.0
FROM dit4c/project-base
MAINTAINER t.dettrick@uq.edu.au

# Install
# - build dependencies for Python PIP
# - PIP to install iPython Notebook dependencies
# - scipy dependencies
RUN yum install -y \
  gcc python-devel \
  python-pip \
  blas-devel lapack-devel

# Install from PIP
# - Notebook dependencies
# - iPython (with notebook)
# - Readline for usability
# - Useful iPython libraries
RUN pip install --upgrade setuptools && \
  pip install \
    tornado pyzmq jinja2 \
    ipython \
    pyreadline \
    ipythonblocks numpy pandas scipy

# Create iPython profile, then
# install MathJAX locally because CDN is HTTP-only
RUN mkdir -p /opt/ipython && \
  IPYTHONDIR=/opt/ipython ipython profile create default && \
  python -c "from IPython.external.mathjax import install_mathjax; install_mathjax()" && \
  chown -R researcher /opt/ipython

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY opt /opt
COPY var /var
# Chowned to root, so reverse that change
RUN chown -R researcher /opt/ipython /var/log/easydav /var/log/supervisor

# Check nginx config is OK
RUN nginx -t
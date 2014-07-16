#!/bin/bash

PACKAGES=(
  # Install build dependencies for Python PIP
  gcc python-devel
  # Install iPython Notebook dependencies
  python-pip
  # Install scipy dependencies
  blas-devel lapack-devel
)
echo ${PACKAGES[@]}

# Installation....
dnf install -y ${PACKAGES[@]}
# Clean-up downloaded packages to save space
dnf clean all && yum clean all

PIP_PACKAGES=(
  # Notebook dependencies
  tornado
  pyzmq
  jinja2
  # iPython (with notebook)
  ipython
  # Readline for usability
  pyreadline
  # Useful iPython libraries
  ipythonblocks
  numpy
  pandas
  scipy
)

# Install iPython blocks
pip install --upgrade setuptools

for P in ${PIP_PACKAGES[*]}
do
  pip install $P || exit 1
done

# Create iPython profile
mkdir -p /opt/ipython
export IPYTHONDIR=/opt/ipython
ipython profile create default
# Install MathJAX, because CDN is HTTP-only
python -c "from IPython.external.mathjax import install_mathjax; install_mathjax()"
chown -R researcher /opt/ipython

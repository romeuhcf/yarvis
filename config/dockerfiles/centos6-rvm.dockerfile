FROM centos:6
MAINTAINER Romeu Fonseca <romeu.hcf@gmail.com>

# enable centos plus repo and install epel repo
RUN sed -i '0,/enabled=.*/{s/enabled=.*/enabled=1/}' /etc/yum.repos.d/CentOS-Base.repo
RUN yum install -y epel-release \
  libyaml-devel \
  glibc-headers \
  autoconf \
  gcc-c++ \
  glibc-devel \
  patch \
  readline-devel \
  zlib-devel \
  libffi-devel \
  openssl-devel \
  bzip2 \
  automake \
  libtool \
  bison \
  sqlite-devel \
  tar \
  which \
  libxml2-devel \
  libxslt1-devel \
  mysql-devel \
  nodejs


# install necessary utilities
RUN groupadd --gid 1000 yarvis
RUN useradd -ms /bin/bash -d /home/yarvis --uid=1000 --gid=1000 yarvis
RUN yum install -y  sudo
RUN echo '%yarvis ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
RUN echo 'Defaults:%yarvis !requiretty' >> /etc/sudoers


# install rvm
RUN su yarvis -c 'curl -sSL https://rvm.io/mpapis.asc | gpg2 --import'
RUN su yarvis -c 'curl -L get.rvm.io | bash -s stable --ruby'

USER yarvis

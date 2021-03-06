FROM ubuntu:12.04
MAINTAINER Romeu Fonseca <romeu.hcf@gmail.com>

RUN apt-get --quiet --yes update && apt-get install -y curl gnupg2 sudo


RUN groupadd --gid 1000 yarvis
RUN useradd -ms /bin/bash --uid=1000 --gid=1000 yarvis
RUN echo '%yarvis ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers 
RUN echo 'Defaults:%yarvis !requiretty' >> /etc/sudoers

# install rvm
RUN apt-get install -y openssl \
  libreadline6 \
  libreadline6-dev \
  curl \
  zlib1g \
  zlib1g-dev \
  libssl-dev \
  libyaml-dev \
  libsqlite3-dev \
  sqlite3 \
  libxml2-dev \
  libxslt-dev \
  autoconf \
  libc6-dev \
  ncurses-dev \
  automake \
  libtool \
  bison \
  subversion \
  pkg-config


RUN su yarvis -c 'bash -cl "curl -sSL https://rvm.io/mpapis.asc | gpg2 --import"'
RUN su yarvis -c 'bash -cl "curl -L get.rvm.io | bash -s stable --ruby"'
RUN su yarvis -c 'bash -cl "rvm install ruby"'

USER yarvis

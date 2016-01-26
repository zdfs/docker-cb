# docker-cb
# =========================================================================

FROM selenium/standalone-chrome
MAINTAINER Zachary Forrest y Salazar <zforrest@gmail.com>

USER root

ENV RUBY_BRANCH 2.3
ENV RUBY_VERSION 2.3.0

# =========================================================================
# Install Ruby Environment
# =========================================================================

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev curl git wget ca-certificates libfreetype6 libfontconfig bzip2 rsync ssh xvfb software-properties-common netcat-openbsd

ADD http://cache.ruby-lang.org/pub/ruby/$RUBY_BRANCH/ruby-$RUBY_VERSION.tar.gz /tmp/

RUN cd /tmp && \
  tar -xzf ruby-$RUBY_VERSION.tar.gz && \
  cd ruby-$RUBY_VERSION && \
  ./configure && \
  make && \
  make install && \
  cd .. && \
  rm -rf ruby-$RUBY_VERSION && \
  rm -f ruby-$RUBY_VERSION.tar.gz

RUN gem install bundler --no-ri --no-rdoc

# =========================================================================
# Install Python
# =========================================================================

RUN \
  apt-get update && \
  apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*

# =========================================================================
# Install NodeJS
# =========================================================================

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL warn
ENV NODE_VERSION 4.2.3

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

CMD [ "node" ]

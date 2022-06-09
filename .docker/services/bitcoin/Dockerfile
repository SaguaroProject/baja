FROM ubuntu:latest AS bitcoin

#
# Set the default bitcoin core version
#
ARG BITCOIN_VERSION=v23.0

#
# Set the source directory for bitcoin core
#
ARG SOURCE_DIR=/usr/local/src/bitcoin

#
# Update Ubuntu
#
RUN apt update && apt -y upgrade

#
# Install dependencies
#
RUN apt -y install  git \
                    clang \
                    build-essential \
                    libtool \
                    autotools-dev \
                    automake \
                    pkg-config \
                    bsdmainutils \
                    python3 \
                    libevent-dev \
                    libboost-dev \
                    libsqlite3-dev \
                    supervisor

#
# Clone bitcoin source
#
RUN git clone https://github.com/bitcoin/bitcoin.git ${SOURCE_DIR}

#
# Set the working directory
#
WORKDIR ${SOURCE_DIR}

#
# Configure bitcoin core build
#
RUN git checkout ${BITCOIN_VERSION} && \
    ./autogen.sh && \
    ./configure CXX=clang++ CC=clang \
    --without-gui \
    --disable-hardening \
    --disable-tests \
    --disable-gui-tests \
    --disable-maintainer-mode \
    --disable-dependency-tracking

#
# Compile and install bitcoin core
#
RUN make && make install

#
# Create command alias
#
RUN echo 'alias bitcoin="bitcoin-cli -datadir=/var/lib/bitcoind -conf=/etc/bitcoin.conf"' >> /etc/bash.bashrc

#
# Copy supervisor configuration
#
COPY supervisord.conf /etc/supervisord.conf

#
# Copy bitcoind init
#
COPY bitcoind.sh /etc/init.d/bitcoind.sh

#
# Copy configuration
#
COPY bitcoin.conf /etc/bitcoin.conf

#
# Start supervisord
#
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

#
# Use pre-build image for peer
#
FROM ghcr.io/saguaroproject/bitcoin:master AS bitcoin-peer

#
# Copy configuration
#
COPY bitcoin-peer.conf /etc/bitcoin.conf
FROM ubuntu:latest AS electrs

#
# Set the default electrs version
#
ARG ELECTRS_VERSION=v0.9.7

#
# Set the source directory for bitcoin core
#
ARG SOURCE_DIR=/usr/local/src/electrs

#
# Update Ubuntu
#
RUN apt update && apt -y upgrade

#
# Install dependencies
#
RUN apt -y install  git \
                    clang \
                    cmake \
                    build-essential \
                    cargo \
                    supervisor

#
# Clone electrs source
#
RUN git clone https://github.com/romanz/electrs.git ${SOURCE_DIR}

#
# Set the working directory
#
WORKDIR ${SOURCE_DIR}

#
# Compile electrs
#
RUN git checkout ${ELECTRS_VERSION} && \
    cargo build \
    --locked \
    --release

#
# Symlink to /usr/local/bin
#
RUN ln -s ${SOURCE_DIR}/target/release/electrs /usr/local/bin/electrs

#
# Copy electrs config
#
COPY config.toml /etc/electrs/config.toml

#
# Copy electrs config
#
COPY config.toml /etc/electrs/config.toml

#
# Copy supervisor configuration
#
COPY supervisord.conf /etc/supervisord.conf

#
# Start supervisord
#
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

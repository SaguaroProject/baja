FROM ubuntu:latest AS esplora

#
# Set the node version
#
ARG NODE_VERSION=v16.10

#
# Set the source directory
#
ARG SOURCE_DIR=/usr/local/src

#
# Update Ubuntu
#
RUN apt update && apt -y upgrade

#
# Install dependencies
#
RUN apt -y install  curl \
                    git \
                    rsync \
                    clang \
                    cmake \
                    build-essential \
                    cargo \
                    nginx \
                    supervisor

#
# Install node
#
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    . ~/.nvm/nvm.sh && \
    nvm install ${NODE_VERSION} && \
    nvm alias default ${NODE_VERSION} && \
    npm install -g npm

#
# Clone electrs source
#
RUN git clone https://github.com/Blockstream/electrs.git ${SOURCE_DIR}/electrs

#
# Clone esplora source
#
RUN git clone https://github.com/Blockstream/esplora.git ${SOURCE_DIR}/esplora

#
# Compile electrs
#
RUN cd ${SOURCE_DIR}/electrs && \
    git checkout new-index && \
    cargo build --release

#
# Compile esplora
#
RUN cd ${SOURCE_DIR}/esplora && \
    . ~/.nvm/nvm.sh && \
    npm install && \
    npm run dist

#
# Copy dist directory
#
RUN rsync -av --delete ${SOURCE_DIR}/esplora/dist/ /var/www

#
# Symlink to /usr/local/bin
#
RUN ln -s ${SOURCE_DIR}/electrs/target/release/electrs /usr/local/bin/electrs

#
# Copy nginx config
#
COPY nginx.conf /etc/nginx/nginx.conf

#
# Copy supervisor configuration
#
COPY supervisord.conf /etc/supervisord.conf

#
# Copy nginx init
#
COPY nginx.sh /etc/init.d/nginx.sh

#
# Copy electrs init
#
COPY electrs.sh /etc/init.d/electrs.sh

#
# Start supervisord
#
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

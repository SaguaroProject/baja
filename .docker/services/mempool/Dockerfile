FROM ubuntu:latest AS mempool

#
# Set the default mempool version
#
ARG MEMPOOL_VERSION=v2.3.1

#
# Set the node version
#
ARG NODE_VERSION=v16.10

#
# Set the source directory for bitcoin core
#
ARG SOURCE_DIR=/usr/local/src/mempool

#
# Update Ubuntu
#
RUN apt update && apt -y upgrade

#
# Install dependencies
#
RUN apt -y install  git \
                    mariadb-client \
                    nginx \
                    curl \
                    rsync \
                    jq \
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
# Clone mempoool source
#
RUN git clone https://github.com/mempool/mempool.git ${SOURCE_DIR}

#
# Set the working directory
#
WORKDIR ${SOURCE_DIR}

#
# Checkout mempool version
#
RUN git checkout ${MEMPOOL_VERSION}

#
# Compile mempool backend
#
RUN cd backend && \
    ~/.nvm/nvm-exec npm install --prod && \
    ~/.nvm/nvm-exec npm run build
    
#
# Compile mempool frontend
#
RUN cd frontend && \
    ~/.nvm/nvm-exec npm install --prod && \
    ~/.nvm/nvm-exec npm run build

#
# Copy frontend
#
RUN rsync -av --delete frontend/dist/ /var/www

#
# Copy config file
#
COPY mempool-config.json ${SOURCE_DIR}/backend/mempool-config.json

#
# Copy nginx configs
#
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-mempool.conf /etc/nginx/nginx-mempool.conf

#
# Copy supervisor configuration
#
COPY supervisord.conf /etc/supervisord.conf

#
# Copy mempool init
#
COPY mempool.sh /etc/init.d/mempool.sh

#
# Copy nginx init
#
COPY nginx.sh /etc/init.d/nginx.sh

#
# Start supervisord
#
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

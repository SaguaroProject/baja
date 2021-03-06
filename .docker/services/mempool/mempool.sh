#!/usr/bin/bash

# MEMPOOL
__MEMPOOL_CHAIN__=${MEMPOOL_BITCOIN_CHAIN:=regtest}
__MEMPOOL_BACKEND__=${MEMPOOL_BACKEND:=electrum}
__MEMPOOL_INITIAL_BLOCKS_AMOUNT__=${MEMPOOL_INITIAL_BLOCKS_AMOUNT:=1}

# BITCOIN CORE
__CORE_RPC_HOST__=${MEMPOOL_BITCOIN_HOST:=127.0.0.1}
__CORE_RPC_PORT__=${MEMPOOL_BITCOIN_RPC_PORT:=18443}
__CORE_RPC_USERNAME__=${MEMPOOL_BITCOIN_RPC_USERNAME:=mempool}
__CORE_RPC_PASSWORD__=${MEMPOOL_BITCOIN_RPC_PASSWORD:=mempool}

# ELECTRUM
__ELECTRUM_HOST__=${MEMPOOL_ELECTRUM_HOST:=127.0.0.1}
__ELECTRUM_PORT__=${MEMPOOL_ELECTRUM_PORT:=50001}
__ELECTRUM_TLS_ENABLED__=${MEMPOOL_ELECTRUM_TLS_ENABLED:=false}

# DATABASE
__DATABASE_ENABLED__=${MEMPOOL_DATABASE_ENABLED:=true}
__DATABASE_HOST__=${MEMPOOL_DATABASE_HOST:=127.0.0.1}
__DATABASE_PORT__=${MEMPOOL_DATABASE_PORT:=3306}
__DATABASE_DATABASE__=${MEMPOOL_DATABASE_DATABASE:=mempool}
__DATABASE_USERNAME__=${MEMPOOL_DATABASE_USERNAME:=mempool}
__DATABASE_PASSWORD__=${MEMPOOL_DATABASE_PASSWORD:=mempool}

MEMPOOL_CONFIG=/usr/local/src/mempool/backend/mempool-config.json

#
# Call bitcoin JSON-RPC
#
function rpc() {
    curl -s \
        --user $__CORE_RPC_USERNAME__:$__CORE_RPC_PASSWORD__ \
        --data-binary '{"jsonrpc":"1.0","id":"curltext","method":"getblockchaininfo","params":[]}' \
        -H 'content-type:text/plain;' \
        $__CORE_RPC_HOST__:$__CORE_RPC_PORT__
}

#
# Check if MariaDB is running and the mempool database has been created
#
function try_mariadb_connect() {
    until mysql --host $__DATABASE_HOST__ --port $__DATABASE_PORT__ -u$__DATABASE_USERNAME__ -p$__DATABASE_PASSWORD__ $__DATABASE_DATABASE__ -e 'SHOW TABLES;' > /dev/null 2>&1
    do
        echo "Unable to connect to to MariaDB. Trying again in 5s..."
        sleep 5s
    done

    echo "Successfully connected to MariaDB."
}

#
# Check to see if there is at least 1 block on the chain
#
try_bitcoin_rpc() {
    until [ $(rpc | jq '.result.blocks') -gt 0 ]
    do
        echo "No blocks found. Trying again in 5s."
        sleep 5s
    done
}

#
# Start the mempool backend server
#
function start() {

    #
    # Wait for MariaDB to start
    #
    try_mariadb_connect

    #
    # Wait until there is at least 1 block
    #
    try_bitcoin_rpc

    #
    # Write environment variables to the config file
    #
    sed -i "s@__MEMPOOL_CHAIN__@${__MEMPOOL_CHAIN__}@g" $MEMPOOL_CONFIG
    sed -i "s@__MEMPOOL_BACKEND__@${__MEMPOOL_BACKEND__}@g" $MEMPOOL_CONFIG
    sed -i "s@__MEMPOOL_INITIAL_BLOCKS_AMOUNT__@${__MEMPOOL_INITIAL_BLOCKS_AMOUNT__}@g" $MEMPOOL_CONFIG

    sed -i "s@__CORE_RPC_HOST__@${__CORE_RPC_HOST__}@g" $MEMPOOL_CONFIG
    sed -i "s@__CORE_RPC_PORT__@${__CORE_RPC_PORT__}@g" $MEMPOOL_CONFIG
    sed -i "s@__CORE_RPC_USERNAME__@${__CORE_RPC_USERNAME__}@g" $MEMPOOL_CONFIG
    sed -i "s@__CORE_RPC_PASSWORD__@${__CORE_RPC_PASSWORD__}@g" $MEMPOOL_CONFIG

    sed -i "s@__ELECTRUM_HOST__@${__ELECTRUM_HOST__}@g" $MEMPOOL_CONFIG
    sed -i "s@__ELECTRUM_PORT__@${__ELECTRUM_PORT__}@g" $MEMPOOL_CONFIG
    sed -i "s@__ELECTRUM_TLS_ENABLED__@${__ELECTRUM_TLS_ENABLED__}@g" $MEMPOOL_CONFIG

    sed -i "s@__DATABASE_ENABLED__@${__DATABASE_ENABLED__}@g" $MEMPOOL_CONFIG
    sed -i "s@__DATABASE_HOST__@${__DATABASE_HOST__}@g" $MEMPOOL_CONFIG
    sed -i "s@__DATABASE_PORT__@${__DATABASE_PORT__}@g" $MEMPOOL_CONFIG
    sed -i "s@__DATABASE_DATABASE__@${__DATABASE_DATABASE__}@g" $MEMPOOL_CONFIG
    sed -i "s@__DATABASE_USERNAME__@${__DATABASE_USERNAME__}@g" $MEMPOOL_CONFIG
    sed -i "s@__DATABASE_PASSWORD__@${__DATABASE_PASSWORD__}@g" $MEMPOOL_CONFIG

    #
    # Start the mempool backend server
    #
    ~/.nvm/nvm-exec npm start
}

#
# Get the status of the mempool process
#
function status() {
    supervisorctl status mempool
}

case "$1" in
    start)
        start
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {start|status}"
        exit 1
        ;;
esac

exit 0
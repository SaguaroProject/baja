#!/usr/bin/bash

# MEMPOOL
__MEMPOOL_NETWORK__=${MEMPOOL_NETWORK:=mainnet}
__MEMPOOL_BACKEND__=${MEMPOOL_BACKEND:=electrum}
__MEMPOOL_INITIAL_BLOCKS_AMOUNT__=${MEMPOOL_INITIAL_BLOCKS_AMOUNT:=1}

# CORE_RPC
__CORE_RPC_HOST__=${CORE_RPC_HOST:=127.0.0.1}
__CORE_RPC_PORT__=${CORE_RPC_PORT:=8332}
__CORE_RPC_USERNAME__=${CORE_RPC_USERNAME:=mempool}
__CORE_RPC_PASSWORD__=${CORE_RPC_PASSWORD:=mempool}

# ELECTRUM
__ELECTRUM_HOST__=${ELECTRUM_HOST:=127.0.0.1}
__ELECTRUM_PORT__=${ELECTRUM_PORT:=50002}
__ELECTRUM_TLS_ENABLED__=${ELECTRUM_TLS_ENABLED:=false}

# DATABASE
__DATABASE_ENABLED__=${DATABASE_ENABLED:=true}
__DATABASE_HOST__=${DATABASE_HOST:=127.0.0.1}
__DATABASE_PORT__=${DATABASE_PORT:=3306}
__DATABASE_DATABASE__=${DATABASE_DATABASE:=mempool}
__DATABASE_USERNAME__=${DATABASE_USERNAME:=mempool}
__DATABASE_PASSWORD__=${DATABASE_PASSWORD:=mempool}

function start() {

    #
    # Write environment variables to the config file
    #
    sed -i "s/__MEMPOOL_NETWORK__/${__MEMPOOL_NETWORK__}/g" mempool-config.json
    sed -i "s/__MEMPOOL_BACKEND__/${__MEMPOOL_BACKEND__}/g" mempool-config.json
    sed -i "s/__MEMPOOL_INITIAL_BLOCKS_AMOUNT__/${__MEMPOOL_INITIAL_BLOCKS_AMOUNT__}/g" mempool-config.json

    sed -i "s/__CORE_RPC_HOST__/${__CORE_RPC_HOST__}/g" mempool-config.json
    sed -i "s/__CORE_RPC_PORT__/${__CORE_RPC_PORT__}/g" mempool-config.json
    sed -i "s/__CORE_RPC_USERNAME__/${__CORE_RPC_USERNAME__}/g" mempool-config.json
    sed -i "s/__CORE_RPC_PASSWORD__/${__CORE_RPC_PASSWORD__}/g" mempool-config.json

    sed -i "s/__ELECTRUM_HOST__/${__ELECTRUM_HOST__}/g" mempool-config.json
    sed -i "s/__ELECTRUM_PORT__/${__ELECTRUM_PORT__}/g" mempool-config.json
    sed -i "s/__ELECTRUM_TLS_ENABLED__/${__ELECTRUM_TLS_ENABLED__}/g" mempool-config.json

    sed -i "s/__DATABASE_ENABLED__/${__DATABASE_ENABLED__}/g" mempool-config.json
    sed -i "s/__DATABASE_HOST__/${__DATABASE_HOST__}/g" mempool-config.json
    sed -i "s/__DATABASE_PORT__/${__DATABASE_PORT__}/g" mempool-config.json
    sed -i "s/__DATABASE_DATABASE__/${__DATABASE_DATABASE__}/g" mempool-config.json
    sed -i "s/__DATABASE_USERNAME__/${__DATABASE_USERNAME__}/g" mempool-config.json
    sed -i "s/__DATABASE_PASSWORD__/${__DATABASE_PASSWORD__}/g" mempool-config.json

    #
    # Start the mempool backend server
    #
    ~/.nvm/nvm-exec npm start
}

case "$1" in 
    start)
       start
       ;;
    *)
       echo "Usage: $0 {start}"
       ;;
esac

exit 0
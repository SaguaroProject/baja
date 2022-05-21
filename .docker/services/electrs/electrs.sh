#!/usr/bin/bash

__BITCOIN_HOST__=${ELECTRS_BITCOIN_HOST:=127.0.0.1}
__BITCOIN_NETWORK__=${ELECTRS_BITCOIN_NETWORK:=regtest}
__BITCOIN_P2P_PORT__=${ELECTRS_BITCOIN_P2P_PORT:=18444}
__BITCOIN_RPC_PORT__=${ELECTRS_BITCOIN_RPC_PORT:=18443}
__BITCOIN_RPC_USERNAME__=${ELECTRS_BITCOIN_RPC_USERNAME:=bitcoin}
__BITCOIN_RPC_PASSWORD__=${ELECTRS_BITCOIN_RPC_PASSWORD:=bitcoin}
__ELECTRUM_RPC_ADDRESS__=${ELECTRS_ELECTRUM_RPC_ADDRESS:=0.0.0.0}
__ELECTRUM_RPC_PORT__=${ELECTRS_ELECTRUM_RPC_PORT:=50001}

ELECTRS_CONFIG=/etc/electrs/config.toml

function start() {

    #
    # Write environment variables to the config file
    #
    sed -i "s@__BITCOIN_HOST__@${__BITCOIN_HOST__}@g" $ELECTRS_CONFIG
    sed -i "s@__BITCOIN_NETWORK__@${__BITCOIN_NETWORK__}@g" $ELECTRS_CONFIG
    sed -i "s@__BITCOIN_P2P_PORT__@${__BITCOIN_P2P_PORT__}@g" $ELECTRS_CONFIG
    sed -i "s@__BITCOIN_RPC_PORT__@${__BITCOIN_RPC_PORT__}@g" $ELECTRS_CONFIG
    sed -i "s@__BITCOIN_RPC_USERNAME__@${__BITCOIN_RPC_USERNAME__}@g" $ELECTRS_CONFIG
    sed -i "s@__BITCOIN_RPC_PASSWORD__@${__BITCOIN_RPC_PASSWORD__}@g" $ELECTRS_CONFIG

    sed -i "s@__ELECTRUM_RPC_ADDRESS__@${__ELECTRUM_RPC_ADDRESS__}@g" $ELECTRS_CONFIG
    sed -i "s@__ELECTRUM_RPC_PORT__@${__ELECTRUM_RPC_PORT__}@g" $ELECTRS_CONFIG

    #
    # Start the electrs server
    #
    /usr/local/bin/electrs
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
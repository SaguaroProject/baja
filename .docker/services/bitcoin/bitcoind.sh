#!/usr/bin/bash

__RPC_SERVER_ENABLED__=${BITCOIN_RPC_SERVER_ENABLED:=1}
__RPC_ALLOW_IP_ADDRESS__=${BITCOIN_RPC_ALLOW_ADDRESS:=0.0.0.0/0}
__TX_INDEX_ENABLED__=${BITCOIN_TX_INDEX_ENABLED:=1}
__REGTEST_CHAIN_ENABLED__=${BITCOIN_REGTEST_CHAIN_ENABLED:=1}
__REGTEST_RPC_BIND_ADDRESS__=${BITCOIN_REGTEST_RPC_BIND_ADDRESS:=0.0.0.0}
__REGTEST_PEER_HOST__=${BITCOIN_REGTEST_PEER_HOST:=bitcoin}
__REGTEST_PEER_PORT__=${BITCOIN_REGTEST_PEER_PORT:=18444}

BITCOIN_RPC_USERNAME=${BITCOIN_RPC_USERNAME:=bitcoin}
BITCOIN_RPC_PASSWORD=${BITCOIN_RPC_PASSWORD:=bitcoin}
__RPC_AUTH_CREDENTIALS__=$(/usr/local/src/bitcoin/share/rpcauth/rpcauth.py $BITCOIN_RPC_USERNAME $BITCOIN_RPC_PASSWORD | grep rpcauth | awk -F "=" '{print $2;}')


BITCOIN_CONFIG=/etc/bitcoin.conf
BITCOIN_DATA_DIR=/var/lib/bitcoind
BITCOIN_CLI="bitcoin-cli -conf=$BITCOIN_CONFIG -datadir=$BITCOIN_DATA_DIR"

#
# Create a new default wallet and mine the first 50 BTC block reward
#
function createwallet() {
    $BITCOIN_CLI getwalletinfo > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "A wallet has already been created."
    else
        wallet=$1
        echo "Creating new wallet..."
        $BITCOIN_CLI createwallet ${wallet:=default} false false "" false true true false > /dev/null 2>&1
        echo "Mining first block..."
        $BITCOIN_CLI generatetoaddress 1 $($BITCOIN_CLI getnewaddress) > /dev/null 2>&1
    fi
}

#
# Start the bitcoin daemon
#
function start() {

    #
    # Write environment variables to the config file
    #
    sed -i "s@__TX_INDEX_ENABLED__@${__TX_INDEX_ENABLED__}@g" $BITCOIN_CONFIG
    
    sed -i "s@__RPC_SERVER_ENABLED__@${__RPC_SERVER_ENABLED__}@g" $BITCOIN_CONFIG
    sed -i "s@__RPC_AUTH_CREDENTIALS__@${__RPC_AUTH_CREDENTIALS__}@g" $BITCOIN_CONFIG
    sed -i "s@__RPC_ALLOW_IP_ADDRESS__@${__RPC_ALLOW_IP_ADDRESS__}@g" $BITCOIN_CONFIG

    sed -i "s@__REGTEST_CHAIN_ENABLED__@${__REGTEST_CHAIN_ENABLED__}@g" $BITCOIN_CONFIG
    sed -i "s@__REGTEST_PEER_HOST__@${__REGTEST_PEER_HOST__}@g" $BITCOIN_CONFIG
    sed -i "s@__REGTEST_PEER_PORT__@${__REGTEST_PEER_PORT__}@g" $BITCOIN_CONFIG   
    sed -i "s@__REGTEST_RPC_BIND_ADDRESS__@${__REGTEST_RPC_BIND_ADDRESS__}@g" $BITCOIN_CONFIG

    #
    # Start the bitcoin daemon
    #
    /usr/local/bin/bitcoind -conf=$BITCOIN_CONFIG \
                            -datadir=$BITCOIN_DATA_DIR \
                            -fallbackfee=${BITCOIN_TX_FALLBACK_FEE:=0.00001}
}

#
# Get the process status
#
function status() {
    supervisorctl status bitcoind
}

case "$1" in 
    start)
        start
        ;;
    status)
        status
        ;;
    createwallet)
        createwallet $2
        ;;
    *)
        echo "Usage: $0 {start|status|createwallet}"
        exit 1
        ;;
esac

exit 0
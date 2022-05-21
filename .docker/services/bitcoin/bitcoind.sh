#!/usr/bin/bash

__RPC_SERVER_ENABLED__=${BITCOIN_RPC_SERVER_ENABLED:=1}
__RPC_AUTH_CREDENTIALS__="${BITCOIN_RPC_AUTH_CREDENTIALS:='root:604dbfc75861c529c3f18c0ea79b7274$ce621931ea4ffca91ad965478d0a877347def92ea31ecc1e2c4b4e9f38416573'}"
__RPC_ALLOW_IP_ADDRESS__=${BITCOIN_ALLOW_RPC_ADDRESS:=0.0.0.0/0}
__TXINDEX_ENABLED__=${BITCOIN_TXINDEX_ENABLED:=1}
__REGTEST_ENABLED__=${BITCOIN_REGTEST_ENABLED:=1}
__REGTEST_RPC_BIND_ADDRESS__=${BITCOIN_REGTEST_RPC_BIND_ADDRESS:=0.0.0.0}
__REGTEST_PEER_HOST__=${BITCOIN_REGTEST_PEER_HOST:=bitcoin}

function start() {

    #
    # Write environment variables to the config file
    #
    sed -i "s@__TXINDEX_ENABLED__@${__TXINDEX_ENABLED__}@g" /etc/bitcoin.conf
    
    sed -i "s@__RPC_SERVER_ENABLED__@${__RPC_SERVER_ENABLED__}@g" /etc/bitcoin.conf
    sed -i "s@__RPC_AUTH_CREDENTIALS__@${__RPC_AUTH_CREDENTIALS__}@g" /etc/bitcoin.conf
    sed -i "s@__RPC_ALLOW_IP_ADDRESS__@${__RPC_ALLOW_IP_ADDRESS__}@g" /etc/bitcoin.conf

    sed -i "s@__REGTEST_ENABLED__@${__REGTEST_ENABLED__}@g" /etc/bitcoin.conf
    sed -i "s@__REGTEST_PEER_HOST__@${__REGTEST_PEER_HOST__}@g" /etc/bitcoin.conf
    sed -i "s@__REGTEST_RPC_BIND_ADDRESS__@${__REGTEST_RPC_BIND_ADDRESS__}@g" /etc/bitcoin.conf

    #
    # Start the electrs server
    #
    /usr/local/bin/bitcoind -conf=/etc/bitcoin.conf \
                            -datadir=/var/lib/bitcoind \
                            -fallbackfee=${BITCOIN_FALLBACK_FEE:=0.00001}
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
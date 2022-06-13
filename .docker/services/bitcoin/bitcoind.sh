#!/usr/bin/bash

BITCOIN_RPC_USERNAME=${BITCOIN_RPC_USERNAME:=bitcoin}
BITCOIN_RPC_PASSWORD=${BITCOIN_RPC_PASSWORD:=bitcoin}
RPC_AUTH_CREDENTIALS=$(/usr/local/src/bitcoin/share/rpcauth/rpcauth.py $BITCOIN_RPC_USERNAME $BITCOIN_RPC_PASSWORD | grep rpcauth | awk -F "=" '{print $2;}')

BITCOIN_CLI="bitcoin-cli -conf=/etc/bitcoin.conf -datadir=/var/lib/bitcoind"

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
    sed -i "s@__RPC_AUTH_CREDENTIALS__@${RPC_AUTH_CREDENTIALS}@g" /etc/bitcoin.conf

    #
    # Start the bitcoin daemon
    #
    exec /usr/local/bin/bitcoind -conf=/etc/bitcoin.conf \
                                 -datadir=/var/lib/bitcoind \
                                 -fallbackfee=${BITCOIN_TX_FALLBACK_FEE:=0.00001}
}

case "$1" in 
    start)
        start
        ;;
    createwallet)
        createwallet $2
        ;;
    *)
        echo "Usage: $0 {start|createwallet}"
        exit 1
        ;;
esac

exit 0
#!/usr/bin/bash

#
# Start electrs
#
function start() {
    exec /usr/local/bin/electrs --db-dir /var/lib/electrs \
                                --daemon-dir /var/lib/bitcoind \
                                --network regtest \
                                --daemon-rpc-addr $BITCOIN_RPC_HOST:$BITCOIN_RPC_PORT \
                                --http-addr 0.0.0.0:3000
}

case "$1" in 
    start)
        start
        ;;
    *)
        echo "Usage: $0 {start}"
        exit 1
        ;;
esac

exit 0
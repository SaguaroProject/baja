#!/usr/bin/bash

#
# Start electrs
#
function start() {
    /usr/local/bin/electrs --db-dir /var/lib/electrs --daemon-dir /var/lib/bitcoind --network regtest --daemon-rpc-addr bitcoin:18443 --http-addr 0.0.0.0:3000
}

#
# Get the status of the electrs process
#
function status() {
    supervisorctl status electrs
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
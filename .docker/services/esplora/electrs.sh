#!/usr/bin/bash

#
# Start electrs
#
function start() {
    exec /usr/local/bin/electrs --db-dir /var/lib/electrs \
                                --daemon-dir /var/lib/bitcoind \
                                --network regtest \
                                --daemon-rpc-addr bitcoin:18443 \
                                --http-addr 0.0.0.0:3000
}

#
# Send a command to supervisord
#
function supervisor() {
    supervisorctl $1 electrs
}

case "$1" in 
    stop|restart|status)
        supervisor $1
        ;;
    start)
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
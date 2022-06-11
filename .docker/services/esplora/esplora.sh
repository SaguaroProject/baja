#!/usr/bin/bash

#
# Start esplora
#
function start() {
    . ~/.nvm/nvm.sh && npm run dev-server
}

#
# Get the status of the esplora process
#
function status() {
    supervisorctl status esplora
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
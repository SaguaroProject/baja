#!/usr/bin/bash

# Start nginx
#
function start() {
    /usr/sbin/nginx -g 'daemon off;'
}

#
# Get the status of the nginx process
#
function status() {
    supervisorctl status nginx
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
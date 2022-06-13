#!/usr/bin/bash

# Start nginx
#
function start() {
    exec /usr/sbin/nginx -g 'daemon off;'
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
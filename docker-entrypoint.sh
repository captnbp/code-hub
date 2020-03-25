#!/bin/bash
set -e

if [ "$1" = 'code-server' ]; then
    exec /usr/local/bin/code-server --host 0.0.0.0 --port 8080 --auth none /home/coder
fi

exec "$@"
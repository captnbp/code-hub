#!/bin/bash
set -e

touch /home/coder/.zshrc

if [ "$1" = 'code-server' ]; then
    exec /usr/bin/code-server --host 127.0.0.1 --port 8080 --auth none /home/coder
fi

exec "$@"
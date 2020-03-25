FROM    codercom/code-server:3.0.1

EXPOSE  8080
COPY    ./install_tools.sh /usr/local/bin/install_tools.sh
COPY    ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER    root
RUN     /usr/local/bin/install_tools.sh

USER    coder

ENTRYPOINT      ["dumb-init", "fixuid", "-q", "docker-entrypoint.sh"]
CMD     ["code-server"]
FROM    ubuntu:20.04

LABEL maintainer="benoit.pourre@doca-consulting.fr"
LABEL app.kubernetes.io/version="3.4.1"
LABEL app.kubernetes.io/managed-by="Helm"
LABEL app.kubernetes.io/part-of="code-server-hub"
LABEL app.kubernetes.io/component="jupyterhub-nginx-oauth"
LABEL source="https://gitlab.com/captnbp/code-server-hub"
LABEL github-project="https://github.com/NYU-CI/jupyterhub-nginx-oauth"

# Install dependencies
RUN apt-get update && apt-get install -y ca-certificates curl dumb-init && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install --no-install-recommends -y python3-dev python3 python3-pip uwsgi uwsgi-plugin-python3 && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache jupyterhub flask

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

EXPOSE 9095

COPY app.py /usr/src/app/app.py

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["uwsgi", "--http-socket", "127.0.0.1:9095", "--uid", "www-data", "--plugins", "python3", "--protocol", "uwsgi", "--manage-script-name", "--mount", "/usr/src/app/=app:app"]
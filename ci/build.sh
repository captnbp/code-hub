#!/bin/bash -e

# build stage script for Auto-DevOps

if ! docker info &>/dev/null; then
  if [ -z "$DOCKER_HOST" ] && [ "$KUBERNETES_PORT" ]; then
    export DOCKER_HOST='tcp://localhost:2375'
  fi
fi

if [[ -n "$CI_REGISTRY" && -n "$CI_REGISTRY_USER" ]]; then
  echo "Logging to GitLab Container Registry with CI credentials..."
  docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" "$CI_REGISTRY"
fi

if [[ -f Dockerfile ]]; then
  echo "Building Dockerfile-based application..."
else
  echo "Building Heroku-based application using gliderlabs/herokuish docker image..."
  erb -T - /build/Dockerfile.erb > Dockerfile
fi

build_secret_args=''
if [[ -n "$AUTO_DEVOPS_BUILD_IMAGE_FORWARDED_CI_VARIABLES" ]]; then
  build_secret_file_path=/tmp/auto-devops-build-secrets
  "$(dirname "$0")"/export-build-secrets > "$build_secret_file_path"
  build_secret_args="--secret id=auto-devops-build-secrets,src=$build_secret_file_path"

  echo 'Activating Docker BuildKit to forward CI variables with --secret'
  export DOCKER_BUILDKIT=1
fi

# pull images for cache - this is required, otherwise --cache-from will not work
docker image pull "$CI_APPLICATION_REPOSITORY:$CI_COMMIT_BEFORE_SHA" || \
docker image pull "$CI_APPLICATION_REPOSITORY:latest" || \
true

# shellcheck disable=SC2154 # missing variable warning for the lowercase variables
# shellcheck disable=SC2086 # double quoting for globbing warning for $build_secret_args and $AUTO_DEVOPS_BUILD_IMAGE_EXTRA_ARGS
docker build \
  --cache-from "$CI_APPLICATION_REPOSITORY:$CI_COMMIT_BEFORE_SHA" \
  --cache-from "$CI_APPLICATION_REPOSITORY:latest" \
  $build_secret_args \
  --build-arg BUILDPACK_URL="$BUILDPACK_URL" \
  --build-arg HTTP_PROXY="$HTTP_PROXY" \
  --build-arg http_proxy="$http_proxy" \
  --build-arg HTTPS_PROXY="$HTTPS_PROXY" \
  --build-arg https_proxy="$https_proxy" \
  --build-arg FTP_PROXY="$FTP_PROXY" \
  --build-arg ftp_proxy="$ftp_proxy" \
  --build-arg NO_PROXY="$NO_PROXY" \
  --build-arg no_proxy="$no_proxy" \
  $AUTO_DEVOPS_BUILD_IMAGE_EXTRA_ARGS \
  --tag "$CI_APPLICATION_REPOSITORY:$CI_APPLICATION_TAG" \
  --tag "$CI_APPLICATION_REPOSITORY:latest" .

docker push "$CI_APPLICATION_REPOSITORY:$CI_APPLICATION_TAG"
docker push "$CI_APPLICATION_REPOSITORY:latest"

#!/usr/bin/env bash

set -eu

root_directory=$(cd "$(dirname "$0")/.." && pwd)
cd "$root_directory"

bash -n shell-scripting/system_info.sh

required_dockerfiles=(
  docker-apps/nodejs-app/Dockerfile
  docker-apps/python-app/Dockerfile
  docker-apps/java-app/Dockerfile
  docker-apps/Apache-app/Dockerfile
  docker-apps/React-app/Dockerfile
  docker-apps/nginx-app/Dockerfile
  multi-stage-build/Dockerfile
)

for dockerfile in "${required_dockerfiles[@]}"; do
  test -s "$dockerfile"
done

docker compose -f docker-apps/compose.yaml config --quiet
docker compose -f docker-networking/compose.yaml config --quiet

echo "Static validation passed"


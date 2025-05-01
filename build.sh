#!/bin/bash
cd "$(dirname "$0")"

docker pull ubuntu:24.04
docker build -t fhp/php-fpm:8.3 --build-arg PHP_VERSION=8.3 .
docker build -t fhp/php-fpm:8.4 --build-arg PHP_VERSION=8.4 .

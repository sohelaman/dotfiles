#!/bin/bash

## Docker images
docker run hello-world

docker pull registry
docker pull ubuntu
docker pull fedora
docker pull debian:stable-slim
docker pull alpine:3
docker pull redis:alpine
docker pull mysql:8.4
docker pull php:8.5-fpm-alpine
docker pull nginx:stable-alpine-slim

docker pull ghcr.io/ggml-org/llama.cpp:server-vulkan
docker pull ghcr.io/ggml-org/llama.cpp:server

## Distrobox images. RUN WITH NON-ROOT USER.
distrobox create -n sandbox -i fedora:44
distrobox create -n ubuntu -i ubuntu:26.04

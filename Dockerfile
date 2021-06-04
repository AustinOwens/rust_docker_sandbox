#title           :Dockerfile
#description     :This file contains instructions for building a docker image.
#                 For example, this file can be executed by running
#                 "docker build -t image_name:latest ."
#author          :Austin Owens
#date            :6/3/2021
#version         :0.1
#common_usage	   :docker build -t <image_name>[:<image_tag>] ./
#notes           :ARG arguments used throughout dockerfile can be overwritten by
#                 passing --build-arg <arg>=<val> to the "docker build" cmd
#                 where <arg> is the argument name and <val> is the value
#docker_version  :20.10.5
#==============================================================================

# Download latest base image from ubuntu
FROM ubuntu:latest

# LABEL about the custom image
LABEL version="0.1"
LABEL description="This is custom Docker Image for a Rust sandbox."

# Starting work directory
WORKDIR /root

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# Update and upgrade Ubuntu software repository and install various packages
# from ubuntu repository
RUN apt-get update && apt-get upgrade -y

# Install various system-level packages from ubuntu repository
RUN apt-get install -y vim curl build-essential git

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Use bash for remaining of file (default is sh)
SHELL ["/bin/bash", "-c"]

# Update Rust
RUN source /root/.cargo/env && rustup update

# Create mount location for user in case they want to share files across host
# and container
VOLUME /mnt/shared

# Coping entrypoint script into /usr/local/bin/
COPY docker_data/docker-entrypoint.sh /usr/local/bin/

# Setting entrypoint script so the container can prepare the environment before
# control is passed to the user
ENTRYPOINT ["docker-entrypoint.sh"]

# Default cmd when starting the container if not overwritten by user.
CMD /bin/bash

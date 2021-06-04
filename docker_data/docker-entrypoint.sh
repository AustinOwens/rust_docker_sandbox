#!/bin/bash

# Make all directories in /mnt/shared/ symbolically link to /root for quicker
# development
for DIR in /mnt/shared/*
do
    ln -s $DIR /root/$(basename $DIR)
done

# Execute CMD in Dockerfile or user specified command passed in over 'docker run'
exec "$@"

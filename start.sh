#!/bin/bash
#title           :start.sh
#description     :This script builds and launches a docker container for
#                 creating a Rust sandbox.
#author	         :Austin Owens
#date            :6/3/2021
#version         :0.1
#usage           :./start.sh [-hb] IMAGE_NAME CONTAINER_NAME
#notes           :Need to have a directory named "shared" in the same location
#                 as this script for shared volume mount.
#notes           :If running docker on windows (unless in WSL2), windows must
#                 give permission to use the shared volume mount (configured
#                 via docker settings).
#bash_version    :4.4.20(1)-release
#==============================================================================

build_image=false

Usage()
{
    echo "This script builds and launches a Rust sandbox docker container."
    echo
    echo "Usage: ./start.sh [-hb] IMAGE_NAME CONTAINER_NAME"
    echo
    echo "Options:"
    echo "h    Print this Help."
    echo "b    Build image. If no changes to the Dockerfile have been made, this flag will do nothing."
    echo
    echo "Arguments:"
    echo "IMAGE_NAME         The name of the created docker image."
    echo "CONTAINER_NAME     The name of the created docker container."
}

RunDocker()
{
    # If the build_image flag is true, build the docker image
    if $build_image; then
        docker build -t $1:latest .
    fi

    # Clean up any dangling images that were left behind
    docker rmi $(docker images -q -f "dangling=true") &> /dev/null

    # Spin up container from image
    docker run -it --rm --name "$2" -v /${PWD}/shared/:/mnt/shared $1
}

# For flags with arguments, add a ":" after the flag below (ex: "h:a" if h has
# an arg associated with it)
while getopts "hbw" flag; do
    case $flag in
        h|\?)
            Usage
            exit 0
            ;;
        b)
            build_image=true
            ;;
    esac
done

# Shifts the positional parameters to the left (to ignore the optional flags
# found by getopts), putting each parameter in a lower position. OPTIND gives
# the position of the next command line argument after the flags.
shift $((OPTIND-1))

# If there arn't 2 positional arguments, prompt user with usage prompt.
if [ $# -ne 2 ]; then
    echo "Warning: Incorrect arguments."
    Usage
else
    RunDocker $1 $2
fi

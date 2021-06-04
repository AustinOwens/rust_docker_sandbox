#!/bin/bash
#title           :clean_up.sh
#description     :This script cleans up containers and images.
#author	         :Austin Owens
#date            :6/3/2021
#version         :0.1
#usage           :./clean_up.sh [-h] IMAGE_NAME CONTAINER_NAME
#notes           :
#bash_version    :4.4.20(1)-release
#==============================================================================

container_name=""
image_name=""

Usage()
{
     echo "This script cleans up containers and images."
     echo
     echo "Usage: ./clean_up.sh [-h] [-c container_name] [-i image_name]"
     echo
     echo "Options:"
     echo "h    Print this Help."
     echo "c    Container name to remove."
     echo "i    Container image to remove."
}

RunDocker()
{
    if [ ! -z $container_name ]
    then
        docker rm $container_name
    fi

    if [ ! -z $image_name ]
    then
        docker rmi $image_name
    fi

    if [ -z $container_name ] && [ -z $image_name ]
    then
        echo "Warning: Must select container_name or image_name to delete."
        Usage
    fi
}

# For flags with arguments, add a ":" after the flag below (ex: "h:a" if h has
# an arg associated with it)
while getopts "hc:i:" flag; do
    case $flag in
        h|\?)
           Usage
           exit 0
           ;;
        c)
           container_name="$OPTARG"
           ;;
        i)
           image_name="$OPTARG"
           ;;
    esac
done

# Shifts the positional parameters to the left (to ignore the optional flags
# found by getopts), putting each parameter in a lower position. OPTIND gives
# the position of the next command line argument after the flags.
shift $((OPTIND-1))

# If there arn't 0 positional arguments, prompt user with usage prompt.
if [ $# -ne 0 ]
then
    echo "Warning: Incorrect arguments."
    Usage
else
    RunDocker
fi

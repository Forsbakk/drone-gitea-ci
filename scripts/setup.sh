#!/bin/bash -eux
 set -e
 set -x
 
 if [ -f /etc/os-release ]; then
   # shellcheck disable=SC1091
   source /etc/os-release
   id=$ID
 
 elif [ -f /etc/redhat-release ]; then
   id="$(awk '{ print tolower($1) }' /etc/redhat-release | sed 's/"//g')"
 fi
 
 if [[ $id == "debian" || $id == "elementary" || $id == "linuxmint" || $id == "ubuntu" ]]; then
   sudo apt-get update -y
   sudo apt-get upgrade -y
 
 elif [[ $id == "fedora" ]]; then
   sudo dnf upgrade -y
 fi

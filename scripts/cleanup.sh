#!/usr/bin/env bash
 set -e
 set -x
 
 if [ -f /etc/os-release ]; then
   # shellcheck disable=SC1091
   source /etc/os-release
   id=$ID
 
 elif [ -f /etc/redhat-release ]; then
   id="$(awk '{ print tolower($1) }' /etc/redhat-release | sed 's/"//g')"
 fi
 
 if [[ $id == "arch" ]]; then
   /usr/bin/yes | sudo /usr/bin/pacman -Scc
 
 elif [[ $id == "centos" || $id == "ol" ]]; then
   sudo yum clean all
   sudo rm -rf /var/cache/yum
 
 elif [[ $id == "debian" || $id == "elementary" || $id == "linuxmint" || $id == "ubuntu" ]]; then
   sudo apt-get clean
 
 elif [[ $id == "fedora" ]]; then
   sudo dnf clean all
   sudo dnf autoremove
 
 elif [[ $id == "opensuse" || $id == "opensuse-leap" ]]; then
   if [ -f /var/lib/misc/random-seed ]; then
     rm /var/lib/misc/random-seed
   fi
   if [ -f /var/lib/systemd/random-seed ]; then
     rm /var/lib/systemd/random-seed
   fi
 fi
 
 # Stop rsyslog service
 if [[ $id != "arch" ]]; then
   sudo service rsyslog stop
 fi
 
 #clear audit logs
 if [ -f /var/log/audit/audit.log ]; then
   sudo bash -c "cat /dev/null > /var/log/audit/audit.log"
 fi
 if [ -f /var/log/wtmp ]; then
   sudo bash -c "cat /dev/null > /var/log/wtmp"
 fi
 if [ -f /var/log/lastlog ]; then
   sudo bash -c "cat /dev/null > /var/log/lastlog"
 fi
 
 #cleanup /tmp directories
 sudo rm -rf /tmp/*
 sudo rm -rf /var/tmp/*
 
 #reset hostname
 sudo bash -c "cat /dev/null > /etc/hostname"
 
 #cleanup shell history
 history -w
 history -c

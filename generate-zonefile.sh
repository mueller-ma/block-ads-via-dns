#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# display date
date

# Set tempfiles
# All_domains will contain all domains from all lists, but also duplicates and ones which are whitelisted
all_domains=$(tempfile)
# Like above, but no duplicates or whitelisted URLs
all_domains_uniq=$(tempfile)
# We don't write directly to the zonefile. Instead to this temp file and copy it to the right directory afterwards
zonefile=$(tempfile)

# StevenBlack GitHub Hosts
# Uncomment ONE line containing the filter you want to apply
# See https://github.com/StevenBlack/hosts for more combinations
wget -q -O StevenBlack-hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling/hosts

# Filter out localhost and broadcast
cat StevenBlack-hosts | grep '^0.0.0.0' | egrep -v '127.0.0.1|255.255.255.255|::1' | cut -d " " -f 2 >> $all_domains

# Filter out comments and empty lines
cat $all_domains | egrep -v '^$|#' | sort | uniq  > $all_domains_uniq

# Add zone information
cat $all_domains_uniq | sed -r 's/(.*)/zone "\1" {type master; file "\/etc\/bind\/db.blocked";};/' > $zonefile

# Copy temp file to right directory
# This is for Debian 8, might differ on other systems
cp $zonefile /etc/bind/named.conf.blocked

# Remove all tempfiles
rm $all_domains $all_domains_uniq $zonefile StevenBlack-hosts

# Restart bind
service bind9 stop
service bind9 start

# For logfile
echo -e 'done\n\n'

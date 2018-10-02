#!/usr/bin/env bash

server=$(nslookup duckduckgo.com | head -n1 | awk '{print $2}')
ip="127.0.0.1"
grep_cmd=$(grep 'nameserver' /etc/resolv.conf)
if [ "$server" == "$ip" ] && \
    [ $(echo $grep_cmd | wc -l) -eq 1 ] && \
    [ $(echo $grep_cmd | awk '{print $2}') = "$ip" ]; then
    echo "up"
else
    echo $(date) >> $HOME/dnslookup
    echo $server >> $HOME/dnslookup
    cat /etc/resolv.conf >> $HOME/dnslookup
    echo "%{F#fb4934}down%{F-}"
fi

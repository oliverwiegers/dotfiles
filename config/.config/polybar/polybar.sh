#!/bin/bash
usage() {
    echo -e "Usage: $0 <BARNAME> <BARNAME>"
    exit 1
}

if [ "$#" -eq 0 ]; then
    usage
fi

pkill -q polybar
for bar in "$@"; do
    polybar "${bar}" &
done

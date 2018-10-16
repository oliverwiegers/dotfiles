#!/bin/sh

if [ $(rfkill list bluetooth | grep -i yes | wc -l) -ne 0 ]; then
    echo "%{F#5b5b5b}%{F-}"
else
    if [ $(bluetoothctl info | wc -l) -eq 1 ];then
        echo ""
    else
	    echo ""
	fi
fi

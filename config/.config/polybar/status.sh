#!/usr/bin/env bash

set -e

daemon=${1:?}
state="%{F#fb4934}down%{F-}"
cmd="$(systemctl status $daemon | grep -i run 2>/dev/null || echo '')"

[[ "$cmd" ]] && state="up"

echo "${state}"
exit 0

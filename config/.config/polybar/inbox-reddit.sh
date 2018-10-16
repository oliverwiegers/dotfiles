#!/bin/sh

url="https://www.reddit.com/message/unread/.json?feed=f739d1af4e57112e84bba77d6e1df69f9ea753b2&user=chrootzius"
unread=$(curl -sf "$url" | jq '.["data"]["children"] | length')

case "$unread" in
    ''|*[!0-9]*)
	unread=0
esac;

echo "$unread"

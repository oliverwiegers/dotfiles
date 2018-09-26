#!/bin/bash
export DISPLAY=:=0
counter=0
done=0
# Todo list entry unsolved should look like: '- [ ] sample enrty'.
# Solved todo list entry should look like: '- [x] solved sample'.
# Regex searches for lines beginning like: '- [x'.
regex="^[-][[:space:]][\[][x].*$"
while read -r item; do
	if [[ $item = \-* ]]; then
		((counter++))
		if [[ ${item,,} =~ $regex ]]; then
			((done++))
		fi
	fi
done < $HOME/Documents/textfiles/todo.md

echo $done/$counter

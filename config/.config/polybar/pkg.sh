#!/bin/bash
pac=$(checkupdates | wc -l)
aur=$(cower -u | wc -l)

echo "$pac %{F#5b5b5b}%{F-} $aur"

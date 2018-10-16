#!/bin/bash
pac=$(checkupdates | wc -l)
aur=$(cower -u | wc -l)

echo "$pac  $aur"

#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
./.fehbg &
unclutter -idle 1 &
compton &
case $(tty | cut -b9-) in
    (1) exec xmonad ;;
    (2) exec startkde;;
esac


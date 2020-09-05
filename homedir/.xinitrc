#!/bin/sh

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Java applicatoins behave wierd without this
export _JAVA_AWT_WM_NONREPARENTING=1
exec bspwm

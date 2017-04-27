if [[ -z $DISPLAY ]] && (( $EUID != 0 )) {
    [[ ${TTY/tty} != $TTY ]] && (( ${TTY:8:1} <= 3 )) &&
        startx 1>~/.log/xsession-errors 2>&1 &
}

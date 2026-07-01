#!/bin/bash

pycommand () {
  python -c "print($1)"
}

hex () {
  python -c "print(hex($1))"
}

bin () {
  python -c "print(bin($1))"
}

tmux_wait_for_pattern () {
    pane=$1  # full pane, e.g. SessionName.01
    pattern=$2  # grep pattern to search for

    if [ "$pane" == "" ]; then
        echo "Must provide pane name. Args: tmux_wait_for_pattern pane pattern"
        return false
    fi
    if [ "$pattern" == "" ]; then
        echo "Must provide a pattern to search for. Args: tmux_wait_for_pattern pane pattern"
        return false
    fi

    until tmux capture-pane -pt "$pane" | grep -q "$pattern"; do
        sleep 0.2
    done
}


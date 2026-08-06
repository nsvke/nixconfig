#! /usr/bin/env bash
#
choice="$(echo -e 'wifi\nbluetooth' | fuzzel --dmenu)"

case "$choice" in
  wifi)
    footclient -a connection-popup -e impala
    ;;
  bluetooth)
    footclient -a connection-popup -e bluetuith
    ;;
esac

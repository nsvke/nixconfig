get_wifi_status() {
  if rfkill list wifi | grep -q "Soft blocked: yes"; then
    echo "off"
    return 0
  fi

  local dev
  dev=$(iwctl device list | awk '/station/ {print $2; exit}')
  
  if [ -z "$dev" ]; then
    echo "off"
    return 0
  fi

  local state ssid
  state=$(iwctl station "$dev" show | awk -F'State[[:space:]]+' '/State/ {print $2}' | xargs)
  
  if [ "$state" = "connected" ]; then
    ssid=$(iwctl station "$dev" show | awk -F'Connected network[[:space:]]+' '/Connected network/ {print $2}' | xargs)
    echo "connected:${ssid:-unknown}"
  else
    echo "disconnected"
  fi
}

get_eth_status() {
  local iface
  iface=$(ip -j route show default 2>/dev/null | jq -r '.[0].dev // empty')
  if [ -n "$iface" ] && [[ "$iface" != wl* ]]; then
    echo "connected:$iface"
  else
    echo "down"
  fi
}

get_bt_status() {
  if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    echo "off"
    return 0
  fi

  local connected_device
  connected_device=$(bluetoothctl devices Connected | head -n 1 | cut -d ' ' -f 3- || true)

  if [ -n "$connected_device" ]; then
    echo "connected:$connected_device"
  else
    echo "disconnected"
  fi
}

toggle_device() {
  local target="$1"
  case "$target" in
    wifi)
      rfkill toggle wifi
      ;;
    bt|bluetooth)
      rfkill toggle bluetooth
      ;;
    *)
      echo "error: invalid toggle target '$target'. Use 'wifi' or 'bt'." >&2
      exit 1
      ;;
  esac
}

CMD="${1:-status}"
TARGET="${2:-all}"

case "$CMD" in
  status)
    case "$TARGET" in
      wifi)
        get_wifi_status
        ;;
      eth)
        get_eth_status
        ;;
      bt|bluetooth)
        get_bt_status
        ;;
      all)
        echo "wifi:$(get_wifi_status) | eth:$(get_eth_status) | bt:$(get_bt_status)"
        ;;
      *)
        echo "error: unknown target '$TARGET'. Use wifi, eth, bt, or all." >&2
        exit 1
        ;;
    esac
    ;;

  toggle)
    if [ "$TARGET" = "all" ]; then
      echo "error: toggle requires a specific target (wifi or bt)." >&2
      exit 1
    fi
    toggle_device "$TARGET"
    ;;

  *)
    echo "usage: hnet [status [wifi|eth|bt|all] | toggle <wifi|bt>]" >&2
    exit 1
    ;;
esac

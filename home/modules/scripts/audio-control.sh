send_notification() {
  local val
  val=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
  notify-send -a "System" -t 1000 \
    -h string:x-canonical-private-synchronous:volume \
    -h "int:value:$val" \
    " $val%"
}

case "$1" in
  up)
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
    send_notification
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    send_notification
    ;;
  mute)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED; then
      notify-send -a "System" -t 1000 \
        -h string:x-canonical-private-synchronous:volume \
        -u low "󰖁 Muted"
    else
      notify-send -a "System" -t 1000 \
        -h string:x-canonical-private-synchronous:volume \
        -u low "󰕾 Not muted"
    fi
    ;;
  mic-mute)
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
    if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
      notify-send -a "System" -t 1000 \
        -h string:x-canonical-private-synchronous:mic \
        -u low "󰍭 Microphone is muted"
    else
      notify-send -a "System" -t 1000 \
        -h string:x-canonical-private-synchronous:mic \
        -u low "󰍬 Microphone is active"
    fi
    ;;
  *)
    echo "invalid arguman. use $0 {up|down|mute|mic-mute}"
    exit 1
    ;;
esac

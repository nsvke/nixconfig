if [ $# -eq 0 ] || [ ! -f "$1" ]; then
  echo "warning: '$1' invalid." >&2
  exit 1
fi

TARGET="$(realpath "$1")"
DEST="$HOME/wallpapers/current"

ln -sf "$TARGET" "$DEST"

OLD_PIDS=$(pidof swaybg)

niri msg action spawn -- swaybg -i "$DEST" -m fill

sleep 0.1

if [ -n "$OLD_PIDS" ]; then
  # shellcheck disable=SC2086
  kill $OLD_PIDS
fi

echo "current wallpaper is $1 now."

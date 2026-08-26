pattern="unexpected"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -e)
      if [[ -n "${2:-}" ]]; then
        pattern="$2"
        shift 2
      else
        echo "error: use -e <pattern>" >&2
        exit 1
      fi
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "error: unexpected arguman '$1'" >&2
      exit 1
      ;;
    *)
      break
      ;;
  esac
done
if [[ $# -eq 0 ]]; then
  echo "usage: chck [-e pattern] <command> [args...]" >&2
  exit 1
fi
output=$("$@" 2>&1) || true
if printf '%s\n' "$output" | rg -q -- "$pattern"; then
  printf '%s\n' "$output" | rg -- "$pattern"
else
  palettes=(
        "198,94,218,130"
        "129,238,171,244"
        "166,94,214,130"
        "30,23,51,36"
  )
  selected_color="${palettes[$RANDOM % ${#palettes[@]}]}"
  cbonsai -b 0 -L 60 -l -i -t 0.02 -w 2 -k "$selected_color"
fi

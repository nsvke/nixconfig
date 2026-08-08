if [ -f "flake.nix" ]; then
  echo "error: flake.nix already exists!" >&2
  exit 1
fi

TMP_TEMPLATE=$(mktemp)
trap 'rm -f "$TMP_TEMPLATE"' EXIT

cat <<'EOF' > "$TMP_TEMPLATE"
{
  description = "dev env template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          name = "dev";
          packages = with pkgs; [ ];
          shellHook = ''
          '';
        };
      });
    };
}
EOF

cp "$TMP_TEMPLATE" flake.nix

hx flake.nix

if [ ! -s "flake.nix" ]; then
  echo "error: flake.nix is empty or missing, aborting." >&2
  exit 1
fi


if cmp -s "flake.nix" "$TMP_TEMPLATE"; then
  echo "aborting.." >&2
  rm -f flake.nix
  exit 0
fi

if [ ! -f ".envrc" ]; then
  echo "use flake" > .envrc
fi

direnv allow

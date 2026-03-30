{
  pkgs,
  unwrapped,
}: let
  nixStorePathSedPattern = "s|/nix/store/[^/]*/bin/||g";
  init = builtins.readFile ./init.lua;
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "sanzenvim-lua";
    version = "0";

    dontUnpack = true;
    nativeBuildInputs = [
      pkgs.gnused
      pkgs.coreutils
    ];

    buildCommand = ''
      mkdir -p "$out"

      nvim_wrapper="${unwrapped}/bin/nvim"
      config_dir=$(${pkgs.gnused}/bin/sed -n "s/.*packpath:prepend('\([^']*\)'.*/\1/p" "$nvim_wrapper")

      if [ -z "$config_dir" ]; then
        echo "Error: Failed to locate config directory from nvim wrapper" >&2
        exit 1
      fi

      ${pkgs.coreutils}/bin/cp -RL "$config_dir/pack" "$out/pack"

      ${unwrapped}/bin/nvf-print-config | \
        ${pkgs.gnused}/bin/sed '${nixStorePathSedPattern}' > "$out/sanzenvim.generated.lua"

      cat > "$out/init.lua" <<'LUA'
      ${init}
      LUA
    '';
  }

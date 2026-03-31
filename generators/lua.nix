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
      pkgs.findutils
    ];

    buildCommand = ''
      mkdir -p "$out"
      nvim_wrapper="${unwrapped}/bin/nvim"
      config_dir=$(${pkgs.gnused}/bin/sed -n "s/.*packpath:prepend('\([^']*\)'.*/\1/p" "$nvim_wrapper")

      tmp_pack=$(${pkgs.coreutils}/bin/mktemp -d)
      ${pkgs.coreutils}/bin/cp -RL "$config_dir/pack" "$tmp_pack/pack"
      ${pkgs.coreutils}/bin/chmod -R +w "$tmp_pack"

      parser_dir="$tmp_pack/pack/mnw/start/nvim-treesitter-grammars/parser"
      if [ -d "$parser_dir" ]; then
        treesitter_parsers=$(
          ${pkgs.findutils}/bin/find "$parser_dir" -type f -name "*.so" -printf "%f\n" | \
          ${pkgs.gnused}/bin/sed 's/\.so$//' | \
          ${pkgs.coreutils}/bin/sort | \
          ${pkgs.coreutils}/bin/tr '\n' ' ' | \
          ${pkgs.gnused}/bin/sed 's/ $//'
        )
      else
        treesitter_parsers=""
      fi
      echo "parsers: $treesitter_parsers" >&2

      ${pkgs.findutils}/bin/find "$tmp_pack/pack" -type f -name "*.so" -delete
      ${pkgs.coreutils}/bin/cp -RL "$tmp_pack/pack" "$out/pack"
      ${pkgs.coreutils}/bin/rm -rf "$tmp_pack"


      ${unwrapped}/bin/nvf-print-config | \
        ${pkgs.gnused}/bin/sed '${nixStorePathSedPattern}' > "$out/sanzenvim.generated.lua"
      cat > "$out/init.lua" <<LUA
      local treesitter_parsers = "$treesitter_parsers"
      ${init}
      LUA
    '';
  }

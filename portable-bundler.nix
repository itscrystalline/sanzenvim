# Portable bundler that works on ALL Linux systems (with or without Nix)
# - On systems WITHOUT Nix: Works as fully portable binary
# - On systems WITH Nix: Can access environment LSPs from /nix/store
#
# This bundler wraps nix-portable and patches it to bind mount host /nix/store

program:
let
  # Get nix-portable bundler
  nix-portable = builtins.getFlake "github:DavHau/nix-portable";
  nixpkgs = import <nixpkgs> {};
  
  # Create base nix-portable bundle
  baseBundle = nix-portable.bundlers.${program.system}.default program;
  
in
nixpkgs.stdenv.mkDerivation {
  name = "portable-${program.name}";
  
  buildInputs = [ nixpkgs.gnused ];
  
  unpackPhase = "true";
  
  buildPhase = ''
    # Extract the nix-portable bundle script
    cp ${baseBundle}/bin/nvim nvim-bundle
    chmod +w nvim-bundle
    
    # Find where the proot command is constructed
    # We need to add a bind mount for host /nix if it exists
    
    # Create a patched version that adds host /nix/store bind mount
    # The trick: add the bind BEFORE the portable nix bind, so host takes precedence
    
    # Insert code to detect and bind host /nix/store
    sed -i '/^# store directory for packages$/i\
# PATCH: Bind host /nix/store if it exists (for environment LSP access)\
if [ -d "/nix/store" ] && [ "$(ls -A /nix/store 2>/dev/null | head -n 1)" ]; then\
  debug "Host /nix/store detected - will bind mount for environment LSP access"\
  HOST_NIX_BINDS="-b /nix:/nix-host"\
else\
  debug "No host /nix/store detected - using portable mode only"\
  HOST_NIX_BINDS=""\
fi\
' nvim-bundle || true
    
    # Add the host nix bind to proot command
    sed -i 's|\(-b \$dir/nix:/nix\)|$HOST_NIX_BINDS \1|' nvim-bundle || true
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    cp nvim-bundle $out/bin/nvim
    chmod +x $out/bin/nvim
  '';
}

{
  full,
  lib,
  ...
}: {
  vim = lib.mkIf full {
    languages.dart = {
      enable = true;
      flutter-tools.enable = true;
    };
    lsp.servers.dart.enable = lib.mkForce false;
  };
}

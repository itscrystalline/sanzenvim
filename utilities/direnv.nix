{pkgs, ...}: {
  vim = {
    utility.direnv.enable = true;
    extraPackages = [pkgs.direnv];
  };
}

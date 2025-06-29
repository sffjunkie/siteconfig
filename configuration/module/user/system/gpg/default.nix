{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.gpg;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    ;
in
{
  options.looniversity.system.gpg.enable = mkEnableOption "gpg";

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.local/share/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 1800;
      pinentry.package = pkgs.pinentry-gtk2;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.network.tool.cli;

  inherit (lib) mkEnableOption mkIf;
in
{
  imports = [
    ./ssh
  ];

  options.looniversity.network.tool.cli = {
    enable = mkEnableOption "networking tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bridge-utils
      dig
      nfs-utils
    ];

    environment.shellAliases = {
      dig = "dig @10.44.0.1";
    };
  };
}

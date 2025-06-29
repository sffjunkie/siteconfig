{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.admin.mongodb;

  desktopItem = pkgs.makeDesktopItem {
    name = "mongodb-compass";
    desktopName = "MongoDB Compass";
    genericName = "MongoDB Compass";
    comment = "MongoDB management";
    icon = "nix-snowflake";
    exec = "mongodb-compass";
    categories = [ "Database" ];
  };

  wrapped = pkgs.symlinkJoin {
    name = pkgs.mongodb-compass.pname;
    paths = [
      desktopItem
      pkgs.mongodb-compass
    ];
  };

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.admin.mongodb = {
    enable = mkEnableOption "mongodb admin";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      wrapped
    ];
  };
}

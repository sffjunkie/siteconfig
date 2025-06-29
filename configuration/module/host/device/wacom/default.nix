{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.device.wacom;

  udev_rule = pkgs.writeTextFile {
    name = "wacom_udev";
    text = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="033c", TAG+="uaccess", TAG+="security-device", MODE="0660"
    '';
    destination = "/lib/udev/rules.d/71-wacom.rules";
  };

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.device.wacom = {
    enable = mkEnableOption "wacom tablet support";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      wacom.enable = true;
    };

    services.udev.packages = [
      udev_rule
    ];
  };
}

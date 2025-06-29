{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.device.yubikey;

  # https://github.com/systemd/systemd/issues/4288#issuecomment-348166161
  udev_rule = pkgs.writeTextFile {
    name = "yubikey_plus_udev";
    text = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0010", TAG+="uaccess", TAG+="security-device", MODE="0660"
    '';
    destination = "/lib/udev/rules.d/71-yubikey_plus.rules";
  };

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.device.yubikey = {
    enable = mkEnableOption "Yubikey Plus udev rule";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      udev_rule
    ];
  };
}

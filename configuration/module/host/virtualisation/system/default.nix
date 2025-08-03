{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.virtualisation.system;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.virtualisation.system = {
    enable = mkEnableOption "virtualisation system config";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm = enabled;
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
        };
      };
      spiceUSBRedirection = enabled;
    };
    services.spice-vdagentd = enabled;

    environment.variables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    environment.systemPackages = [
      pkgs.spice
      pkgs.spice-gtk
      pkgs.spice-protocol
      pkgs.virt-manager
      pkgs.virt-viewer
      pkgs.python3Packages.libvirt
    ];

    system.userActivationScripts.virshNetAutostart = ''
      virsh net-autostart default
    '';
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}

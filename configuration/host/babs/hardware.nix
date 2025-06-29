{
  config,
  lib,
  ...
}:
{
  config = {
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}

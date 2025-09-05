{ lib, ... }:
{
  options.sopsFiles = lib.mkOption {
    type = lib.types.attrsOf lib.types.path;
  };

  config = {
    sopsFiles = {
      default = ./secrets.yaml;
      home-automation = ./home-automation.yaml;
      network = ./network.yaml;
      service = ./service.yaml;
      tool = ./tool.yaml;
      user = ./user.yaml;
    };
  };
}

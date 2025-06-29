{
  config = {
    programs.home-manager.enable = true;

    home = {
      username = "nixos";
      homeDirectory = "/home/nixos";
      stateVersion = "23.05";
      file = {
        ".sops.yaml".source = ../../../../.sops.yaml;
      };
    };
  };
}

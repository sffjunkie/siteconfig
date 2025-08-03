{
  config,
  lib,
  pkgs,
  # isoTarget ? "/run/media/sdk/Ventoy/",
  ...
}:
let
  system = "x86_64-linux";
in
{
  imports = [
    ../secret
    ./user/nixos/host
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault system;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    home-manager.users.nixos = import ./user/nixos/home;

    # system.build.isoImage.isoName = lib.mkDefault "looniversity-minimal-${system}.iso";

    # environment.etc = {
    #   "wpa_supplicant.conf".source = config.sops.templates."wpa_supplicant".path;
    # };

    environment.systemPackages = [
      pkgs.age
      pkgs.gitMinimal
      pkgs.gnumake
      pkgs.jq
      pkgs.just
      pkgs.sops
      pkgs.ssh-to-age
      pkgs.yq
    ];

    services.openssh.enable = true;

    sops = {
      defaultSopsFormat = "yaml";

      secrets."looniversity/wifi/Acme" = {
        sopsFile = config.sopsFiles.network;
      };

      templates."wpa_supplicant" = {
        content = ''
          ctrl_interface=/run/wpa_supplicant
          ctrl_interface_group=wheel
          update_config=1
          network = {
              ssid=Acme"
              psk=${config.sops.placeholder."looniversity/wifi/Acme"}
          }
        '';
      };
    };

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFugnsOEmySWbh2hIrAjroWAO+PB4RznGnt+oDuERsU"
    ];

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}

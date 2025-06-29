{
  config,
  pkgs,
  ...
}:
let
  username = "sdk";
in
{
  imports = [
    ./backup/local.nix
    ./backup/nas.nix
    ./settings
  ];

  config = {
    # https://github.com/Mic92/sops-nix#setting-a-users-password
    sops.secrets."${username}/password_hash" = {
      neededForUsers = true;
      sopsFile = config.sopsFiles.user;
    };

    users.users.${username} = {
      isNormalUser = true;
      uid = 1001;
      description = "me";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "podman"
        "libvirtd"
      ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFugnsOEmySWbh2hIrAjroWAO+PB4RznGnt+oDuERsU ${username}"
        ];
      };
      hashedPasswordFile = config.sops.secrets."${username}/password_hash".path;
    };

    services.openssh.settings.AllowUsers = [ username ];
  };
}

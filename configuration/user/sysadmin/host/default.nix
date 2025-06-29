{
  config,
  pkgs,
  ...
}:
let
  username = "sysadmin";
in
{
  config = {
    # https://github.com/Mic92/sops-nix#setting-a-users-password
    sops.secrets."${username}/password_hash" = {
      neededForUsers = true;
      sopsFile = config.sopsFiles.user;
    };

    users.users.${username} = {
      isNormalUser = true;
      uid = 1000;
      description = "System Administrator";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "podman"
      ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO17K8Ei9367OcAQtB/u/LXb9elGRGJh0p4S9n6DrBy9 ${username}"
        ];
      };
      hashedPasswordFile = config.sops.secrets."${username}/password_hash".path;
    };

    services.openssh.settings.AllowUsers = [ username ];
  };
}

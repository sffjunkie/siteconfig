{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  username = "nixos";
in
{
  config = {
    # sops.secrets."${username}/password_hash" = {
    #   neededForUsers = true;
    #   sopsFile = config.sopsFiles.user;
    # };

    users.users.${username} = {
      isNormalUser = true;
      uid = 1100;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA8Ayl5f2l+BFrUTzbyzmiLbhmYzTaLptCwe80Vk84NJ ${username}"
        ];
      };
      initialHashedPassword = lib.mkForce "$y$j9T$Zsnex9xmak8RwTOJo08Fo1$IE9JWi5khDdfY0TpM8T33jDgCpJvYC4zMNFSPv9qKw/";
      # hashedPasswordFile = config.sops.secrets."${username}/password_hash".path;
    };

    services.openssh.settings.AllowUsers = [ username ];
  };
}

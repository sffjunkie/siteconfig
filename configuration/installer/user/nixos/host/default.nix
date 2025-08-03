{
  config,
  pkgs,
  sops,
  ...
}:
let
  username = "nixos";
in
{
  config = {
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
    };

    services.openssh.settings.AllowUsers = [ username ];
  };
}

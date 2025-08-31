{ lib, ... }:
let
  inherit (lib) disabled enabled;
in
{
  imports = [
    ../../common
  ];

  config = {
    programs.home-manager = enabled;

    home = {
      username = "sysadmin";
      homeDirectory = "/home/sysadmin";
      stateVersion = "23.05";

      sessionVariables = {
        VAULT_ADDR = "http://thebrain.looniversity.net:8200";
      };
    };

    looniversity = {
      cli = {
        zoxide = enabled;
      };
      shell = {
        zsh = enabled;
      };
      system = {
        gpg = enabled;
      };
    };
  };
}

{
  config,
  lib,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.lldap;
  lanDev = lib.network.netDevice config "pinky" "lan";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.lldap = {
    enable = mkEnableOption "lldap";
  };

  config = mkIf cfg.enable {
    sops.secrets."lldap/jwt" = {
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."lldap/key_seed" = {
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."lldap/admin_password" = {
      sopsFile = config.sopsFiles.service;
    };

    sops.templates."lldap_env_file" = {
      content = ''
        LLDAP_KEY_SEED=${config.sops.placeholder."lldap/key_seed"}
        LLDAP_JWT_SECRET=${config.sops.placeholder."lldap/jwt"}
        LLDAP_LDAP_USER_PASS=${config.sops.placeholder."lldap/admin_password"}
      '';
    };

    services.lldap = {
      enable = true;

      settings = {
        http_url = "http://ldap.looniversity.net";
        ldap_base_dn = "dc=looniversity,dc=net";
        database_url = "sqlite:////var/lib/lldap/lldap.db?mode=rwc";
        ldap_user_dn = "admin";
        ldap_user_email = "sdk@looniversity.lan";
      };

      environmentFile = config.sops.templates."lldap_env_file".path;
    };

    networking.firewall.interfaces = {
      ${lanDev} = {
        allowedTCPPorts = [ config.services.lldap.settings.ldap_port ];
      };
    };
  };
}

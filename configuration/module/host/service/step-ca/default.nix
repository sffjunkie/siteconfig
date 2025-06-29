{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.step-ca;
  lanDev = lib.network.netDevice config "pinky" "lan";

  inherit (lib) mkEnableOption mkIf types;
  inherit (builtins) isNull;
in
{
  options.looniversity.service.step-ca = {
    enable = mkEnableOption "step-ca";
  };

  config = mkIf cfg.enable {
    sops.secrets."step_ca/intermediate_password" = {
      owner = config.users.users.step-ca.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."step_ca/certs/root_ca_crt" = {
      owner = config.users.users.step-ca.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."step_ca/certs/intermediate_ca_crt" = {
      owner = config.users.users.step-ca.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."step_ca/secrets/intermediate_ca_key" = {
      owner = config.users.users.step-ca.name;
      sopsFile = config.sopsFiles.service;
    };

    services.step-ca = {
      enable = true;
      address = "ca.service.looniversity.net";
      port = 8443;
      openFirewall = true;
      intermediatePasswordFile = "${config.sops.secrets."step_ca/intermediate_password".path}";

      settings = {
        commonName = "Looniversity CA";
        root = config.sops.secrets."step_ca/certs/root_ca_crt".path;
        crt = config.sops.secrets."step_ca/certs/intermediate_ca_crt".path;
        key = config.sops.secrets."step_ca/secrets/intermediate_ca_key".path;

        db = {
          type = "badgerv2";
          dataSource = "/var/lib/step-ca/db";
        };

        dnsNames = [
          "ca.service.looniversity.net"
        ];

        logger = {
          format = "text";
        };

        authority = {
          provisioners = [
            {
              type = "JWK";
              name = "sdk@looniversity.lan";
              key = {
                use = "sig";
                kty = "EC";
                kid = "j9JYoLebdf9vjKqtuJxOoZSSFE-p9PJZuKosRH3mh6g";
                crv = "P-256";
                alg = "ES256";
                x = "zu-oL6-wCyLJJbO15L1JZ7axpf3ndK0N-QCz-1e-vRA";
                y = "PTXjiuEfE8N0Z-rOKDcAaf_RVT5WrpaF-bxq3n4kCsQ";
              };
              encryptedKey = "eyJhbGciOiJQQkVTMi1IUzI1NitBMTI4S1ciLCJjdHkiOiJqd2sranNvbiIsImVuYyI6IkEyNTZHQ00iLCJwMmMiOjEwMDAwMCwicDJzIjoiWGNBY0JabFVNc0tZQXFsalFvSnRYQSJ9.9dXFg7SJ6TWCPjWi_wRvvDU9uG6HbeAN2AU34W4RvYXIhkwcR4qMeA.mUEbpb7xo-47_giA.WvC3Rllsj7ZXgSUXrJLd-9iROqzxZDWNTApSkWrO7CY87ZOkCvmYdIplzXUg_sqk299xyYFJc73WpcO1_0pGDRNC2eXC-UQC5Ok4KvOeolMuHr1SHtXxV0K7Z0Slkwc91nwkd9B9NZFZxSs1wF6C6h_K-M3ywv2pJNYxI9_0STFS5oGu0VH0rJ3RtmFqjm3yEiqtV7I8MAy7Kw9OsR6USyHzJrrs8HouyQfCKS4W2yHj9j00EAMqzrd7sv8eZyP5SIUV6Do7RuIXZR6wu_UOFF44ueC5mauyNN7DAsGRA_Nm61vkDy7vBj4QE-l-0KltSo5BKnV47SbT-iwuCiw.oE9IRbvI1Yk6v7UklxJnzw";
            }

            {
              type = "ACME";
              name = "acme";
              claims = {
                enableSSHCA = true;
                disableRenewal = false;
                allowRenewalAfterExpiry = false;
              };
              options = {
                x509 = { };
                ssh = { };
              };
            }
          ];
        };

        tls = {
          cipherSuites = [
            "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
            "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
          ];
          minVersion = 1.2;
          maxVersion = 1.3;
          renegotiation = false;
        };
      };
    };

    networking.firewall.interfaces = {
      ${lanDev} = {
        allowedTCPPorts = [ config.services.step-ca.port ];
      };
    };

    environment.systemPackages = [
      pkgs.step-cli
    ];
  };
}

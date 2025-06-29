{
  config,
  pkgs,
  ...
}:
# let
#   p = config.age.secrets.secret-mail-looniversity.path;
# in
{
  config.programs.mbsync.enable = true;

  config.accounts.email = {
    maildirBasePath = ".local/share/email";

    accounts = {
      looniversity = {
        primary = true;
        flavor = "plain";
        userName = "sdk";
        realName = "Simon Kennedy";
        address = "sdk@looniversity.lan";

        passwordCommand = "${pkgs.pinentry-gtk2}/bin/pinentry";
        mbsync = {
          enable = true;
          create = "maildir";
          extraConfig = {
            channel = {
              Sync = "All";
            };
          };
        };

        imap = {
          host = "mail.looniversity.lan";
          port = 143;
          tls = {
            enable = false;
          };
        };
      };
    };
  };
}

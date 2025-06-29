{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.service.homepage-dashboard;
in
{
  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      widgets = [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];

      services = [
        {
          "Home Automation" = [
            { "Home Assistant" = [ { href = "https://hass.looniversity.net"; } ]; }
          ];
        }
      ];

      bookmarks = [
        {
          Google = [
            { GMail = [ { href = "https://mail.google.com"; } ]; }
            { Calendar = [ { href = "https://calendar.google.com"; } ]; }
            { Keep = [ { href = "https://keep.google.com"; } ]; }
            { Account = [ { href = "https://myaccount.google.com/"; } ]; }
          ];
        }

        {
          News = [
            { BBC = [ { href = "https://news.bbc.co.uk/"; } ]; }
            { Semafor = [ { href = "https://semafor.com"; } ]; }
            { Feedly = [ { href = "https://feedly.com"; } ]; }
            { RSS = [ { href = "http://rss.looniversity.net"; } ]; }
          ];
        }

        {
          Microsoft = [
            { Office = [ { href = "https://www.office.com/"; } ]; }
            { OneDrive = [ { href = "https://onedrive.live.com/"; } ]; }
            { Account = [ { href = "https://account.microsoft.com/"; } ]; }
          ];
        }

        {
          Social = [
            {
              Reddit = [
                {
                  abbr = "RE";
                  href = "https://reddit.com/";
                }
              ];
            }
            { "Hacker News" = [ { href = "http://news.ycombinator.com"; } ]; }
          ];
        }

        {
          Entertainment = [
            {
              YouTube = [
                {
                  abbr = "YT";
                  href = "https://youtube.com/";
                }
              ];
            }
          ];
        }

        {
          "Developer Accounts" = [
            {
              Github = [
                {
                  abbr = "GH";
                  href = "https://github.com/sffjunkie";
                }
              ];
            }
            { PyPI = [ { href = "https://pypi.org/manage/projects/"; } ]; }
          ];
        }

        {
          Domains = [
            { "Google Domains" = [ { href = "https://domains.google.com/registrar/"; } ]; }
          ];
        }
      ];
    };
  };
}

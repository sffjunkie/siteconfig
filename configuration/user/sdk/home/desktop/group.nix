{
  config,
  lib,
  pkgs,
  ...
}:
let
  settingsFormat = pkgs.formats.yaml { };
in
{
  config = {
    xdg.configFile."desktop/group.yaml".source = settingsFormat.generate "desktop-group.yaml" {
      layout = "monadtall";
      decoration = true;
      groups = [
        {
          name = "WWW";
          layout = "monadtall";
          matches = {
            app_id = [
              "brave-browser"
              "chromium"
              "firefox"
            ];
          };
        }
        {
          name = "BRAIN";
          layout = "max";
          matches = {
            app_id = [ "obsidian" ];
          };
        }
        {
          name = "CODE";
          layout = "max";
          matches = [ "code-url-handler" ];
        }
        {
          name = "TERM";
          layout = "monadtall";
        }
        {
          name = "DOC";
          layout = "monadtall";
        }
        {
          name = "CHAT";
          layout = "monadtall";
        }
        {
          name = "VID";
          layout = "monadtall";
        }
        {
          name = "GFX";
          layout = "max";
          matches = {
            app_id = [
              "Darktable"
              "Gimp-\d+\.\d+"
              "org\.inkscape\.Inkscape"
            ];
          };
        }
      ];
    };
  };
}

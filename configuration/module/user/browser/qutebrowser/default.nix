{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.qutebrowser;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };

  config = mkIf cfg.enable {
    stylix.targets.qutebrowser.enable = true;

    programs.qutebrowser = {
      enable = true;

      searchEngines = {
        g = "https://www.google.co.uk/search?hl=en&q={}";
        nw = "https://nixos.wiki/index.php?search={}";
        wp = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
      };

      settings = {
        fonts = {
          default_family = lib.mkDefault "JetBrainsMono Nerd Font Mono";
          default_size = lib.mkDefault "16pt";
          # web.size = {
          #   default = lib.mkDefault 22;
          #   default_fixed = lib.mkDefault 22;
          #   minimum = lib.mkDefault 18;
          # };
        };
        tabs = {
          position = "left";
          show = "multiple";
        };
        content.tls.certificate_errors = "ask-block-thirdparty";
      };
    };
  };
}

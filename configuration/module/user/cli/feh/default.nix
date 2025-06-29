{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.feh;

  buttonsFile = ''
    # Unbind existing scroll operations
    prev_img
    next_img
    # Set <action> <mouse button>
    zoom_in 4
    zoom_out 5
  '';

  themesFile = ''
    default -Gd -B black --draw-tinted --scale-down -g "2880x1620+480+270" --font "Roboto-Regular/13" --fontpath ${pkgs.roboto}/share/fonts/truetype/ --info 'echo "Size: %wx%h, Format: %t, Pixels: %P"'
    slideshow -G -B black --draw-tinted --fullscreen --font "Roboto-Regular/13" --fontpath ${pkgs.roboto}/share/fonts/truetype/ --slideshow-delay 3 --info ';echo "Size: %wx%h, Format: %t, Pixels: %P"'
  '';

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.feh = {
    enable = mkEnableOption "feh";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.feh
    ];

    xdg.configFile."feh/buttons".text = buttonsFile;
    xdg.configFile."feh/themes".text = themesFile;

    programs.zsh.shellAliases = {
      feh = "feh -Tdefault";
      fehs = "feh -Tslideshow";
    };
  };
}

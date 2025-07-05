{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.window_manager.qtile;

  python = pkgs.python3;

  reloadScript = pkgs.writeShellScriptBin "qtile_reload" ''
    ${python.pkgs.qtile}/bin/qtile cmd-obj -o cmd -f reload_config
  '';

  startScript = pkgs.writeScript "startqtile" ''
    #! ${pkgs.zsh}/bin/zsh

    # first import environment variables from the login manager
    export XDG_DATA_DIRS=/run/current-system/sw/share/gsettings-schemas:$XDG_DATA_DIRS
    systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY

    ${pkgs.zsh}/bin/zsh --login -c "systemctl --user import-environment PATH XDG_DATA_DIRS ${toString cfg.extraEnvVars}"

    # then start the service
    exec systemctl --user --wait start qtile.service
  '';

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.desktop.window_manager.qtile = {
    enable = mkEnableOption "qtile";
    extraPythonPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      description = ''
        A function that returns a list of packages from a package set
        to be added to the default packages required by qtile.
      '';
    };
    extraEnvVars = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra environment variables needed by the qtile config.
      '';
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        A systemd environment file to pass secrets needed by the qtile config.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "qtile";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    environment.systemPackages = [
      reloadScript
    ];

    looniversity.desktop.greeter.tuigreet.script = "${startScript}";

    systemd.user.targets.qtile-session = {
      description = "Qtile compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.user.services.qtile =
      let
        pyEnv = python.withPackages (
          ps:
          [
            ps.qtile
            ps.iwlib
          ]
          ++ (cfg.extraPythonPackages ps)
        );
      in
      {
        description = "Qtile - Wayland window manager";
        documentation = [ "man:qtile(5)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];

        # We explicitly unset PATH here, as we want it to be set by
        # systemctl --user import-environment in startqtile
        environment.PATH = lib.mkForce null;
        environment.PYTHONPATH = lib.mkForce null;

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pyEnv}/bin/qtile start --backend wayland --config %h/.config/qtile";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;

          EnvironmentFile = (mkIf (cfg.environmentFile != null) cfg.environmentFile);
        };
      };
  };
}

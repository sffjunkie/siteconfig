{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.starship;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.cli.starship = {
    enable = mkEnableOption "starship";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        format = "$username$hostname$directory$git_branch$git_commit$git_state$git_metrics$cmd_duration$fill$direnv$env_var$python$nodejs$line_break$character";
        username = {
          format = "[$user]($style) ";
        };
        hostname = {
          format = "[$ssh_symbol$hostname]($style) ";
        };
        directory = {
          truncate_to_repo = false;
        };
        fill = {
          symbol = " ";
        };
        direnv = {
          disabled = false;
        };
        env_var = {
          variable = "DEVENV_ROOT";
          style = "blue";
          format = "[devenv ]($style)";
        };
        python = {
          python_binary = "python3";
          style = "green";
          symbol = "🐍";
          format = "[python=(\${version} )(venv=$virtualenv )]($style)";
        };
        nodejs = {
          style = "green";
          format = "[node@($version )]($style)";
        };
      };
    };
  };
}

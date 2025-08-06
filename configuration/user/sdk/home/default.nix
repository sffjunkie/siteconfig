{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  ageKeyFile = "/home/sdk/.config/sops/age/keys.txt";
  mpdConfig = config.looniversity.music.mpd;
  inherit (lib) disabled enabled;
in
{
  imports = [
    ./accounts
    ./desktop

    ../../common

    # inputs.qde.nixosModules.qtile
  ];

  # config = osConfig.home-manager.users.${user}.config
  config = {
    nixpkgs.config.permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];

    programs.home-manager = enabled;
    home = {
      username = "sdk";
      homeDirectory = "/home/sdk";
      stateVersion = "23.05";
      sessionVariables = {
        BROWSER = "brave";
        EDITOR = "micro";
        TERMINAL = "alacritty";

        MANWIDTH = 100;
        VAULT_ADDR = "http://thebrain.looniversity.net:8200";
        DEVELOPMENT_HOME = "$HOME/development";

        SOPS_AGE_KEY_FILE = ageKeyFile;
      };
    };

    sops = {
      age.keyFile = ageKeyFile;
    };

    stylix = {
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      targets = {
        firefox.profileNames = [ "default" ];
        vscode.enable = false;
      };
    };

    xdg.mime = enabled;

    looniversity = {
      audio = {
        easyeffects = disabled;
        qpwgraph = enabled;
        volumectl = enabled;
      };

      cli = {
        atuin = disabled;
        bat = enabled;
        beancount = enabled;
        bottom = enabled;
        cava = enabled // {
          settings = {
            input = {
              method = "${mpdConfig.outputType}";
              source = "mpd.${mpdConfig.outputName}";
            };
          };
        };
        dircolors = enabled;
        exiftool = enabled;
        fd = enabled;
        feh = enabled;
        fzf = enabled;
        gh = enabled;
        git = enabled;
        htop = enabled;
        jc = enabled;
        jq = enabled;
        just = enabled;
        khal = enabled;
        lazydocker = enabled;
        lazygit = enabled;
        lsd = enabled;
        neofetch = enabled;
        pass = enabled;
        pulsemixer = enabled;
        ranger = enabled;
        ripgrep = enabled;
        slurm = enabled;
        starship = enabled;
        youtubeDl = enabled;
        yq = enabled;
        yubikeyManager = enabled;
        zellij = enabled;
      };

      desktop = {
        dunst = disabled;
        mako = enabled;
        wallpaper = enabled;
      };

      development = {
        alejandra = enabled;
        devenv = enabled;
        direnv = enabled;
        gnumake = enabled;
        nixfmt = enabled;
        pre-commit = enabled;
        shellcheck = enabled;
        treefmt = enabled;
      };

      game = {
        openmw = enabled;
      };

      gui = {
        fava = enabled;
        firefox = enabled;
        google-chrome = enabled;
        brave = enabled;
        darktable = enabled;
        discord = enabled;
        gimp = enabled;
        gittyup = enabled;
        gnomeApps = enabled;
        gns3 = enabled;
        gramps = enabled;
        inkscape = enabled;
        keepassxc = enabled;
        libreoffice = enabled;
        mpv = enabled;
        obsidian = enabled;
        picard = enabled;
        qutebrowser = enabled;
        rofi = enabled;
        seahorse = enabled;
        streamdeck = enabled;
        thunderbird = enabled;
        wofi = enabled;
        zathura = enabled;
      };

      editor = {
        micro = enabled;
        nixvim = enabled;
        vscode = enabled // {
          git = enabled;
          just = enabled;
          markdown = enabled;
          nix = enabled;
          python = enabled;
          shellcheck = enabled;
          toml = enabled;

          theme.catppuccin = enabled;
        };
      };

      keyboard = {
        input-remapper = disabled;
        hyper_super = enabled;
      };

      terminal = {
        alacritty = enabled;
        kitty = disabled;
      };

      tui = {
        bagels = enabled;
      };

      media = {
        playerctl = enabled;
      };

      music = {
        mpd = enabled // {
          uid = osConfig.users.users.sdk.uid;
        };
        musicctl = enabled;
        ncmpcpp = enabled;
        notify = enabled;
        rmpc = enabled;
      };

      role = {
        podcaster = enabled;
      };

      script = {
        linkhandler = enabled;
        paths = enabled;
        sysinfo = enabled;
      };

      security = {
        passage = enabled;
      };

      service = {
        syncthing = enabled;
      };

      settings = {
        gnome = enabled;
      };

      shell = {
        nushell = enabled;
        zsh = enabled // {
          initContent = ''
            bindkey ^f autosuggest-accept
            function edit() { command "''${EDITOR:-${config.home.sessionVariables.EDITOR}}" "$@"; }
            function fjq() { cat "$1" | ${pkgs.jq}/bin/jq .; }
          '';
        };
      };

      storage = {
        udiskie = enabled;
        veracrypt = enabled;
      };

      system = {
        gpg = enabled;
        imagemagick = enabled;
        polkit-agent = enabled;
        pywal = enabled;
        user-dirs = enabled;
      };

      wayland = {
        clipboard.cliphist = enabled;
        display = {
          kanshi = enabled;
          wdisplays = enabled;
        };
        screenshot.sshot = enabled;
        lockscreen.swaylock = enabled;
      };
    };
  };
}

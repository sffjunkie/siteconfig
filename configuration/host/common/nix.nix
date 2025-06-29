{
  config = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      trusted-users = [ "sdk" ];
    };

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp/nix-daemon";
  };
}

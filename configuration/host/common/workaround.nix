{
  config = {
    # https://discourse.nixos.org/t/logrotate-config-fails-due-to-missing-group-30000/28501/2
    services.logrotate.checkConfig = false;
  };
}

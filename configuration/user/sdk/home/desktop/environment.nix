{ config, sops, ... }:
{
  config = {
    sops.secrets."sdk/location/latitude" = {
      sopsFile = config.sopsFiles.user;
    };

    sops.secrets."sdk/location/longitude" = {
      sopsFile = config.sopsFiles.user;
    };

    sops.secrets."sdk/api_key/owm" = {
      sopsFile = config.sopsFiles.user;
    };

    sops.templates."location_conf" = {
      content = ''
        USER_LOCATION_LATITUDE=${config.sops.placeholder."sdk/location/latitude"}
        USER_LOCATION_LONGITUDE=${config.sops.placeholder."sdk/location/longitude"}
        OWM_API_KEY=${config.sops.placeholder."sdk/api_key/owm"}
      '';
      path = "${config.xdg.configHome}/environment.d/location.conf";
    };
  };
}

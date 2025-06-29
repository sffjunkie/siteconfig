{ inputs, ... }:
{
  imports = [
    ../../module/user
    ../../role/user
    ../../secret
    ../../var
  ];

  config = {
    sops = {
      defaultSopsFormat = "yaml";
    };

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}

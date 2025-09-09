{
  lib,
  inputs,
  ns,
  ...
}:
let
  inherit (inputs) deploy-rs;
in
rec {
  ## Create deployment configuration for use with deploy-rs.
  ##
  ## ```nix
  ## mkDeploy {
  ##   inherit self;
  ##   overrides = {
  ##     my-host.system.sudo = "doas -u";
  ##   };
  ## }
  ## ```
  ##
  #@ { self: Flake, targets: listOf str, overrides: Attrs ? {} } -> Attrs
  mkDeploy =
    {
      self,
      targets ? [ ],
      overrides ? { },
    }:
    let
      hosts = self.nixosConfigurations or { };
      hostNames = (if builtins.length targets != 0 then targets else builtins.attrNames hosts);
      nodes = lib.foldl (
        result: name:
        let
          host = hosts.${name};
          inherit (host.pkgs) system;
        in
        result
        // {
          ${name} = (overrides.${name} or { }) // {
            hostname = overrides.${name}.hostname or "${name}";
            profiles = (overrides.${name}.profiles or { }) // {
              system = (overrides.${name}.profiles.system or { }) // {
                path = deploy-rs.lib.${system}.activate.nixos host;
                user = "sysadmin";
                sshUser = "sysadmin";
              };
            };
          };
        }
      ) { } hostNames;
    in
    {
      inherit nodes;
    };
}

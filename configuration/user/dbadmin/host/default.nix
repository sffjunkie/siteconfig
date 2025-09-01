{
  config,
  pkgs,
  ...
}:
let
  username = "dbadmin";
in
{
  config = {
    users.users.${username} = {
      isNormalUser = true;
      uid = 999;
      description = "Database Administrator";
    };
  };
}

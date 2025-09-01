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
      uid = 1002;
      description = "Database Administrator";
    };
  };
}

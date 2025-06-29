{
  config.accounts.calendar = {
    basePath = ".local/share/calendar";

    accounts = {
      personal = {
        primary = true;
        primaryCollection = "personal";
        local = {
          type = "filesystem";
        };
        khal = {
          enable = true;
          type = "calendar";
          color = "light blue";
        };
      };
      work = {
        local = {
          type = "filesystem";
        };
        khal = {
          enable = true;
          type = "calendar";
          color = "light green";
        };
      };
    };
  };
}

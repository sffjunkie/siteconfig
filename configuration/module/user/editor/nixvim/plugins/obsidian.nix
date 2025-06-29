{
  config = {
    programs.nixvim.plugins.obsidian = {
      enable = true;

      settings = {
        workspaces = [
          {
            name = "Personal";
            path = "~/persona/personal/brain";
          }
          {
            name = "Work";
            path = "~/persona/work/brain";
          }
        ];

        daily_notes = {
          # Optional, if you keep daily notes in a separate directory.
          folder = "Daily\ Notes";
          # Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d";
        };

        completion = {
          # Trigger completion at 2 chars.
          min_chars = 2;
        };
      };
    };
  };
}

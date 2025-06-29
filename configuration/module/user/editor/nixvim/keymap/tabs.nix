{
  config = {
    programs.nixvim = {
      extraConfigLua = ''
        for i=1,9,1
        do
          map('n', '<leader>'..i, i.."gt", {})
        end
        map('n', '<leader>0', ":tablast<cr>", {})
      '';
    };
  };
}

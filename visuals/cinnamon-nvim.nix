{...}: {
  vim.visuals.cinnamon-nvim = {
    enable = true;
    setupOpts = {
      keymaps = {
        basic = true;
        extra = true;
      };
      options = {
        delay = 2;
        max_delta = {
          line = false;
          column = false;
          time = 500;
        };
      };
    };
  };
  vim.keymaps = [
    {
      mode = "n";
      key = "<C-d>";
      action = ''function() require("cinnamon").scroll("<C-d>zz") end'';
      lua = true;
      silent = true;
      desc = "Allow <C-d> and <C-u> to keep the cursor in the middle";
    }
    {
      mode = "n";
      key = "<S-Down>";
      action = ''function() require("cinnamon").scroll("<S-Down>zz") end'';
      lua = true;
      silent = true;
      desc = "Allow <S-Up> and <S-Down> to keep the cursor in the middle";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = ''function() require("cinnamon").scroll("<C-u>zz") end'';
      lua = true;
      silent = true;
      desc = "Allow C-d and C-u to keep the cursor in the middle";
    }
    {
      mode = "n";
      key = "<S-Up>";
      action = ''function() require("cinnamon").scroll("<S-Up>zz") end'';
      lua = true;
      silent = true;
      desc = "Allow <S-Up> and <S-Down> to keep the cursor in the middle";
    }
  ];
}

{
  # pkgs,
  # lib,
  # config,
  # options,
  ...
}: {
  vim.keymaps = [
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>w<cr><esc>";
      silent = true;
      desc = "Save file";
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>quitall<cr><esc>";
      silent = true;
      desc = "Quit all";
    }
    {
      mode = "n";
      key = "<leader>QQ";
      action = "<cmd>quitall!<cr><esc>";
      silent = true;
      desc = "Quit all";
    }

    # Toggle
    {
      mode = "n";
      key = "<leader>ul";
      action = ":lua vim.o.number = not vim.o.number<cr>";
      silent = true;
      desc = "Toggle Line Numbers";
    }
    {
      mode = "n";
      key = "<leader>uL";
      action = ":lua vim.o.relativenumber = not vim.o.relativenumber<cr>";
      silent = true;
      desc = "Toggle Relative Line Numbers";
    }

    {
      mode = "v";
      key = "<A-Down>";
      action = ":m '>+1<CR>gv=gv";
      silent = true;
      desc = "Move down when line is highlighted";
    }
    {
      mode = "v";
      key = "<A-Up>";
      action = ":m '<-2<CR>gv=gv";
      silent = true;
      desc = "Move up when line is highlighted";
    }
    {
      mode = "n";
      key = "<A-Down>";
      action = ":m .+1<CR>==";
      silent = true;
      desc = "Move line down";
    }
    {
      mode = "n";
      key = "<A-Up>";
      action = ":m .-2<CR>==";
      silent = true;
      desc = "Move line up";
    }
    {
      mode = "v";
      key = "<";
      action = "<gv";
      silent = true;
      desc = "Indent while remaining in visual mode.";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      silent = true;
      desc = "Indent while remaining in visual mode.";
    }

    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
      silent = true;
      desc = "Allow cursor to stay in the same place after appeding to current line";
    }

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

    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      desc = "Allow search terms to stay in the middle";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      desc = "Allow search terms to stay in the middle";
    }

    {
      mode = "x";
      key = "<leader>p";
      action = "\"_dP";
      desc = "Deletes to void register and paste over";
    }

    {
      mode = "v";
      key = "y";
      action = "ygv<Esc>";
      silent = true;
      desc = "Return to original position after yank";
    }
    {
      mode = "v";
      key = "<leader>y";
      action = "\"+ygv<Esc>";
      desc = "Copy to system clipboard";
    }
    {
      mode = "n";
      key = "<leader>y";
      action = "\"+yy";
      desc = "Copy to system clipboard";
    }
    {
      mode = "v";
      key = "<leader>Y";
      action = "\"+Ygv<Esc>";
      desc = "Copy to system clipboard";
    }
    {
      mode = "n";
      key = "<leader>Y";
      action = "\"+Y";
      desc = "Copy to system clipboard";
    }
    {
      mode = ["n" "v"];
      key = "<leader>p";
      action = "\"+p";
      desc = "Paste from system clipboard";
    }
    {
      mode = ["n" "v"];
      key = "<leader>P";
      action = "\"+P";
      desc = "Paste from system clipboard";
    }

    {
      mode = ["n" "v"];
      key = "<leader>D";
      action = "\"_d";
      desc = "Delete to void register";
    }

    {
      mode = "n";
      key = "<leader>o";
      action = ":Oil --float<CR>";
      desc = "Open Oil on parent dir";
      silent = true;
    }

    {
      mode = "t";
      key = "<C-x>";
      action = "<C-\\><C-n>";
      desc = "Escape out of Terminal mode";
      silent = true;
    }

    {
      mode = "n";
      key = "<leader>nv";
      action = ":ToggleTerm direction=vertical";
      desc = "Open Vertical Terminal";
      silent = true;
    }
    {
      mode = "n";
      key = "<leader>nf";
      action = ":ToggleTerm direction=float";
      desc = "Open Vertical Terminal";
      silent = true;
    }
  ];
}

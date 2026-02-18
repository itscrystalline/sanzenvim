{...}: {
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
      key = "<leader>Q";
      action = "<cmd>quitall!<cr><esc>";
      silent = true;
      desc = "Quit all (don't save)";
    }

    {
      mode = "n";
      key = "<leader>s";
      action = ":let @/=\"\"<CR>";
      silent = true;
      desc = "Clear search highlights";
    }

    # windows
    {
      mode = "n";
      key = "<leader>ww";
      action = "<C-W>p";
      silent = true;
      desc = "Other window";
    }
    {
      mode = "n";
      key = "<leader>wq";
      action = "<C-W>c";
      silent = true;
      desc = "Delete window";
    }
    {
      mode = "n";
      key = "<leader>w-";
      action = "<C-W>s";
      silent = true;
      desc = "Split window below";
    }
    {
      mode = "n";
      key = "<leader>w|";
      action = "<C-W>v";
      silent = true;
      desc = "Split window right";
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<C-W>s";
      silent = true;
      desc = "Split window below";
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<C-W>v";
      silent = true;
      desc = "Split window right";
    }
    {
      mode = "n";
      key = "<leader>w=";
      action = "<C-W>w+";
      silent = true;
      desc = "Increase window size";
    }
    {
      mode = "n";
      key = "<leader>w_";
      action = "<C-W>w-";
      silent = true;
      desc = "Decrease window size";
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
      key = "<C-h>";
      action = "<C-w>h";
      desc = "Focus left window";
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<C-w>h";
      desc = "Focus left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      desc = "Focus bottom window";
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<C-w>j";
      desc = "Focus bottom window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      desc = "Focus left window";
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<C-w>k";
      desc = "Focus top window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      desc = "Focus right window";
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<C-w>l";
      desc = "Focus right window";
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
      mode = "t";
      key = "<C-x>";
      action = "<C-\\><C-n>";
      desc = "Escape out of Terminal mode";
      silent = true;
    }
  ];
}

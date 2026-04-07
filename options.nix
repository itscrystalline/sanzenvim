{
  lib,
  full,
  ...
}: {
  vim = {
    options = {
      number = true;
      relativenumber = true;

      mouse = "a";

      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      showtabline = 2;
      expandtab = true;
      smartindent = true;

      breakindent = true;

      hlsearch = true;
      incsearch = true;

      wrap = true;

      splitbelow = true;
      splitright = true;

      ignorecase = true;
      smartcase = true; # Don't ignore case with capitals
      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m";

      updatetime = 50; # faster completion (4000ms default)

      completeopt = lib.concatStringsSep "," [
        "menuone"
        "noselect"
        "noinsert"
      ]; # mostly just for cmp

      swapfile = false;
      backup = false;
      undofile = true;

      # Enable 24-bit colors
      termguicolors = true;

      # Enable the sign column to prevent the screen from jumping
      signcolumn = "yes";

      # Enable cursor line highlight
      cursorline = false; # Highlight the line where the cursor is located

      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      # too much eats into text
      scrolloff = 2;
      timeoutlen = 200;
      encoding = "utf-8";
      fileencoding = "utf-8";
      list = true; # Show invisible characters (tabs, eol, ...)
      listchars = "eol:↲,tab:|->,lead:·,space: ,trail:•,extends:→,precedes:←,nbsp:␣";
      fillchars = "eob: ";

      showmode = false;

      pumheight = 0;

      laststatus = 3; # (https://neovim.io/doc/user/options.html#'laststatus')

      inccommand = "split"; # (https://neovim.io/doc/user/options.html#'inccommand')
    };

    # turn this off if having issues
    enableLuaLoader = true;

    withPython3 = full;
    withNodeJs = full;

    highlight.EndOfBuffer.blend = 0;
  };
}

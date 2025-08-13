{
  # pkgs,
  lib,
  # config,
  # options,
  ...
}: {
  vim.options = {
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

    # We don't need to see things like INSERT anymore
    showmode = false;

    # Maximum number of items to show in the popup menu (0 means "use available screen space")
    pumheight = 0;

    # formatexpr = "v:lua.require'conform'.formatexpr()";

    laststatus = 3; # (https://neovim.io/doc/user/options.html#'laststatus')

    inccommand = "split"; # (https://neovim.io/doc/user/options.html#'inccommand')
  };

  # turn this off if having issues
  vim.enableLuaLoader = true;
}

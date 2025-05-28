{
  # When editing a file, always jump to the last known cursor position.
  # Don't do it when the position is invalid or when inside an event handler
  # (happens when dropping a file on gvim).
  # Also don't do it when the mark is in the first line, that is the default
  # position when opening a file.
  autoCmd = [
    {
      event = "BufReadPost";
      pattern = "*";
      command = ''
        if line("'\"") > 1 && line("'\"") <= line("$") |
          exe "normal! g`\"" |
        endif
      '';
    }
  ];

  clipboard.providers.wl-copy.enable = true;

  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavor = "mocha";
      integrations = {
        cmp = true;
        gitsigns = true;
        treesitter = true;
      };
      transparent_background = true;
    };
  };

  globals = {
    loaded_ruby_provider = 0;
    loaded_perl_provider = 0;
    loaded_python_provider = 0; # Python 2
  };

  keymaps = [
    {
      key = "<Tab>";
      action = "<Esc>";
    }
  ];

  opts = {
    number = true;
    mouse = "a";
    mousemodel = "extend";
    mousefocus = true;
    mousehide = false;
    hidden = true;
    undofile = true;
    termguicolors = true;
    ignorecase = true;
    smartcase = true;
    expandtab = true;
    foldlevel = 10;
    splitbelow = true;
    splitright = true;
    scrolloff = 3;
  };

  plugins = {
    airline.enable = true;
    barbar.enable = true;
    comment.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
    lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        cmake.enable = true;
        nil_ls.enable = true;
        rls.enable = true;
        ruff.enable = true;
      };
    };
    lsp-format.enable = true;
    lsp-status.enable = true;
    lsp-signature.enable = true;
    lz-n.enable = true;
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight.enable = true;
      };
    };
    hmts.enable = true;
    web-devicons.enable = true;
  };
}

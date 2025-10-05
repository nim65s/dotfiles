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
      mode = "ca";
      key = "^";
      action = "q";
    }
    {
      mode = "ca";
      key = "^a";
      action = "qa";
    }
    {
      mode = "ca";
      key = "%";
      action = "w";
    }
    {
      mode = "ca";
      key = "%a";
      action = "wa";
    }
    {
      mode = "ca";
      key = "[";
      action = "x";
    }
    {
      mode = "ca";
      key = "[a";
      action = "xa";
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
    foldlevel = 20;
    splitbelow = true;
    splitright = true;
    scrolloff = 3;
  };

  plugins = {
    airline.enable = true;
    barbar = {
      enable = true;
      keymaps = {
        next.key = "<TAB>";
        previous.key = "<S-TAB>";
      };
    };
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
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save.__raw = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
          end
        '';
        formatters_by_ft = {
          nix = [ "nixfmt" ];
        };
      };
    };
    kitty-scrollback.enable = true;
    lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        # cmake.enable = true;
        nil_ls.enable = true;
        rust_analyzer.enable = true;
        ruff.enable = true;
      };
    };
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

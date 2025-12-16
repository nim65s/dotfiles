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

  filetype = {
    pattern = {
      "patch-.*" = "diff";
    };
  };

  globals = {
    loaded_ruby_provider = 0;
    loaded_perl_provider = 0;
    loaded_python_provider = 0; # Python 2
    mapleader = " ";
  };

  keymaps = [
    # Ergo-L too slow release of AltGr for :
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
    # faster copy/paste
    {
      mode = "v";
      key = "<leader>y";
      action = "\"+y";
    }
    {
      mode = "n";
      key = "<leader>p";
      action = "\"+p";
    }
    # get diagnostic
    {
      mode = "n";
      key = "<leader>d";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
    }
    # get corrections
    {
      mode = "n";
      key = "<leader>c";
      action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
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
    list = true;
    listchars = "nbsp:¤,tab:▷·,trail:¤,extends:>,precedes:<";
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
      settings = {
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
        };
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
      };
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
        formatters = {
          formatjson5 = {
            command = "formatjson5";
            args = [ "-" ];
          };
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          json = [ "jq" ];
          json5 = [ "formatjson5" ];
          typst = [ "typstyle" ];
        };
      };
    };
    fileline.enable = true;
    kitty-scrollback.enable = true;
    lsp = {
      enable = true;
      servers = {
        clangd.enable = true;
        # cmake.enable = true;
        nil_ls.enable = true;
        rust_analyzer = {
          enable = true;
          # I prefer rustc from rust-overlay in devShells
          installCargo = false;
          installRustc = false;
        };
        ruff.enable = true;
        ty.enable = true;
      };
    };
    lsp-status.enable = true;
    lsp-signature.enable = true;
    lz-n.enable = true;
    plantuml-syntax.enable = true;
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

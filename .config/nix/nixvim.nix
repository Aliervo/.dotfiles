{ pkgs }:
{
  enable = true;

  autoCmd = [
    {
      desc = "Format files using LSP before saving.";
      event = ["BufWritePre"];
      pattern = "*";
      command = "lua vim.lsp.buf.format()";
    }
  ];

  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };
  
  # Broken right now work around with extraConfigLuaPost
  # colorscheme = "solarized-flat";
  extraConfigLuaPost = "vim.cmd [[ colorscheme solarized-flat ]]";

  extraConfigLua = "require('ephemeral')";

  extraPackages = [
    pkgs.fd
    pkgs.ripgrep
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-solarized-lua
    # pkgs.kakounePlugins.parinfer-rust
  ];

  opts = {
    tabstop = 2;
    softtabstop = -1;
    shiftwidth = 0;
    shiftround = true;
    smartindent = true;
    expandtab = true;
    termguicolors = true;
    foldlevel = 99;
  };

  keymaps = [
    {
      options.desc = "Makes escape behave as expected in terminal mode.";
      mode = "t";
      key = "<Esc>";
      action = ''<C-\><C-n>'';
    }
    {
      options.desc = "zellij-nav: Navigate left or tab";
      mode = "n";
      key = "<a-h>";
      action = "<cmd>ZellijNavigateLeftTab<cr>";
    }
    {
      options.desc = "zellij-nav: Navigate down";
      mode = "n";
      key = "<a-j>";
      action = "<cmd>ZellijNavigateDown<cr>";
    }
    {
      options.desc = "zellij-nav: Navigate up";
      mode = "n";
      key = "<a-k>";
      action = "<cmd>ZellijNavigateUp<cr>";
    }
    {
      options.desc = "zellij-nav: Navigate right or tab";
      mode = "n";
      key = "<a-l>";
      action = "<cmd>ZellijNavigateRightTab<cr>";
    }
    {
      options.desc = "zk.nvim: Open notes.";
      mode = "n";
      key = "<leader>zo";
      action = "<Cmd>ZkNotes { sort = { 'modified' } }<CR>";
    }
    {
      options.desc = "zk.nvim: Open notes associated with the selected tags.";
      mode = "n";
      key = "<leader>zt";
      action = "<Cmd>ZkTags<CR>";
    }
    {
      options.desc = "zk.nvim: Search for notes matching a given query.";
      mode = "n";
      key = "<leader>zf";
      action = "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>";
    }
    {
      options.desc = "zk.nvim: Create a new note after asking for its title.";
      mode = "n";
      key = "<leader>zn";
      action = "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>";
    }
    {
      options.desc = "zk.nvim: Search for the notes matching the current visual selection";
      mode = "v";
      key = "<leader>zf";
      action = ":'<,'>ZkMatch<CR>";
    }
  ];

  plugins = {
    cmp = {
      enable = true;
      # cmdline = {};
      # filetype = {};
      # luaConfig = {};
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };

    comment.enable = true;

    indent-blankline = {
      enable = true;

      settings.indent.char = [ "|" "¦" "┆" "┊" ];
    };

    lsp = {
      enable = true;

      servers = {
        bashls.enable = true;
        cssls.enable = true;
        denols.enable = true;
        eslint.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        tailwindcss.enable = true;
        ts_ls.enable= true;
      };

      keymaps = {
        diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
        };
        extra = [
          {
            options.desc = "telescope.nvim: Goto definition";
            action = {
              __raw = "require('telescope.builtin').lsp_definitions";
            };
            key = "gd";
          }
          {
            options.desc = "telescope.nvim: Goto diagnostics";
            action = {
              __raw = "require('telescope.builtin').diagnostics";
            };
            key = "gh";
          }
          {
            options.desc = "telescope.nvim: Goto implementation";
            action = {
              __raw = "require('telescope.builtin').lsp_implementations";
            };
            key = "gi";
          }
          {
            options.desc = "telescope.nvim: Goto type references";
            action = {
              __raw = "require('telescope.builtin').lsp_references";
            };
            key = "gD";
          } 
          {
            options.desc = "telescope.nvim: Goto type definitions";
            action = {
              __raw = "require('telescope.builtin').lsp_type_definitions";
            };
            key = "gt";
          } 
        ];
      };
    };

    luasnip = {
      enable = false;

      fromVscode = [ # Something wrong here. Keep disabled for now.
        {}
        {
          paths = "${pkgs.vimPlugins.friendly-snippets}";
        }
      ];
    };

    nvim-autopairs.enable = true;

    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>fh" = "help_tags";
        "<leader>ft" = "builtin";
      };
    };

    treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
        indent.enable = true;
      };
      folding = true;
    };

    web-devicons.enable = true;

    zellij-nav.enable = true;

    zk = {
      enable = true;
      settings.picker = "telescope";
    };
  };

  viAlias = true;
  vimAlias = true;
}

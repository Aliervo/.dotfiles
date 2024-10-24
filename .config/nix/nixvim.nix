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
  
  colorscheme = "solarized-flat";

  extraConfigLua = "require('ephemeral')";

  extraPackages = [
    pkgs.fd
    pkgs.ripgrep
  ];

  extraPlugins = with pkgs.vimPlugins; [
    nvim-solarized-lua
    pkgs.kakounePlugins.parinfer-rust
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
      options.desc = "zk.nvim: Search for the notes matching the current visual selection";
      mode = "v";
      key = "<leader>zf";
      action = ":'<,'>ZkMatch<CR>";
    }
  ];

  plugins = {
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

    zk = {
      enable = true;
      settings.picker = "telescope";
    };
  };

  viAlias = true;
  vimAlias = true;
}

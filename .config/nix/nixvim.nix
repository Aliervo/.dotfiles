{ pkgs }:
{

    enable = true;

    colorscheme = "solarized-flat";

    extraConfigLua = "require('ephemeral')";

    extraPackages = [
      pkgs.fd
      pkgs.ripgrep
    ];

    extraPlugins = [
      pkgs.vimPlugins.nvim-solarized-lua
    ];

    options = {
      tabstop = 2;
      softtabstop = -1;
      shiftwidth = 0;
      shiftround = true;
      smartindent = true;
      expandtab = true;
      termguicolors = true;
    };

    maps = {
      terminal."<Esc>".action = ''<C-\><C-n>'';
    };

    plugins = {
      comment-nvim.enable = true;

      indent-blankline = {
        enable = true;

	charList = [ "|" "¦" "┆" "┊" ];
	showCurrentContext = true;
	showCurrentContextStart = true;
	#useTreesitter = true;
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
	  lua-ls.enable = true;
	  nil_ls.enable = true;
	  rust-analyzer.enable = true;
	  tailwindcss.enable = true;
	  tsserver.enable= true;
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
        indent = true;
      };
    };

    viAlias = true;
    vimAlias = true;

}

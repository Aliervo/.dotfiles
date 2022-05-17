-- Packer plugin setup
require('packer').startup(function()
	-- Have packer manage itself
	use 'wbthomason/packer.nvim'

	-- Enable treesitter with post-install/update hook
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	-- Enable the lspconfig
	use { 
    "williamboman/nvim-lsp-installer",
    {
      'neovim/nvim-lspconfig',
      config = function()
        require("nvim-lsp-installer").setup{
          automatic_installation = true
        }
        local lspconfig = require("lspconfig")
        lspconfig.tsserver.setup{}
        lspconfig.html.setup{}
        lspconfig.svelte.setup{}
      end
    }
  }

  -- Enable LuaSnip
  use 'L3MON4D3/LuaSnip'

  -- Enable Ledger Support
  use 'ledger/vim-ledger'
end)

-- Automatically run :PackerSync whenever plugins.lua is updated
vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerSync]])

require('nvim-treesitter.configs').setup {
	ensure_installed = "all",
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
}

-- require('luasnip')

-- Bootstrap Packer if it isn't already installed
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
	-- Have packer manage itself
	use 'wbthomason/packer.nvim'

	-- Enable treesitter with post-install/update hook
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	-- Enable the lspconfig with auto server installation
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

  -- Enable Autopairs
  use "windwp/nvim-autopairs"

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require("packer").sync()
  end
end)

-- Configure Autopairs
require("nvim-autopairs").setup({ map_cr = true })

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

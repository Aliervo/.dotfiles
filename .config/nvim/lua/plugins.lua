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
          local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
          local lspconfig = require("lspconfig")
          lspconfig.tsserver.setup{
            capabilities = capabilities
          }
          lspconfig.html.setup{
            capabilities = capabilities
          }
          lspconfig.svelte.setup{
            capabilities = capabilities
          }
              end
            }
          }

  -- Enable Autocompletion and Snippets
  use {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "saadparwaiz1/cmp_luasnip"
  }

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

-- Configure Autocomplete and Snippets
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(arg.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  })
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  })
})
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

require('mappings')
require('plugins')

local options = {
  tabstop = 2,
  softtabstop = -1,
  shiftwidth = 0,
  shiftround = true,
  smartindent = true,
	expandtab = true
}

for k, v in pairs(options) do vim.o[k] = v end

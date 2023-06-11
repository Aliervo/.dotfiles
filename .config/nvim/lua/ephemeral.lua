-- Use this file for quick nvim configuration changes without rebuilding nixVim

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

--vim.opt.termguicolors = true
--vim.cmd("colorscheme solarized-flat")

-- Set new telescope keymaps
--local builtin = require('telescope.builtin')
--vim.keymap.set('n', '<leader>ft', builtin.builtin, {})

-- Change indent character
--require("indent_blankline").setup {
  --char_list = { '|', '¦', '┆', '┊' },
  --show_current_context = true,
  --show_current_context_start = true,
  --use_treesitter = true
--}

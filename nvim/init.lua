-- Basic
require('core.plugins')
require('core.mappings')
require('core.colors')
require('core.configs')

-- Plugins
require('plugins.treesitter')
require('plugins.bufferline')
vim.lsp.enable('pyright')

require'nvim-treesitter'.install { 'lua', 'pascal', 'python' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

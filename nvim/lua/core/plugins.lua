-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { 'phaazon/hop.nvim' },
    
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim", 
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim", 
        "s1n7ax/nvim-window-picker"
      },
    },
    
{
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate'
},
{ 'neovim/nvim-lspconfig' },
{ 'folke/tokyonight.nvim' },
{
    "mason-org/mason.nvim",
    opts = {}
},

{'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
{
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    }
},
  {'akinsho/toggleterm.nvim', version = "*", config = true},

{
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
        check_ts = true, -- интегрирует autopairs с вашим nvim-treesitter
        ts_config = {
            lua = {'string'}, -- не добавлять пары в строках lua
            javascript = {'template_string'}, 
        },
        fast_wrap = { -- зажимаете Alt+e, чтобы обернуть слово в скобки
            map = '<M-e>',
            chars = { '{', '[', '(', '"', "'" },
            pattern = [=[[%'%"%)%>%]%]%}%,]]=],
            offset = 0,
            keys = 'qwertyuiopzxcvbnmasdfghjkl',
        },
    }
}
},

  
{  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
  }
})

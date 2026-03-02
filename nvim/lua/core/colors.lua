vim.opt.termguicolors = true

function SetColor(color)
	color = "tokyonight-night"
	vim.cmd.colorscheme(color)
end
SetColor()

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			vim.o.statusline = " "
		else
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		-- Исправляем внутренние требования lualine
		local lualine_require = require("lualine_require")
		lualine_require.require = require

		-- Безопасное получение иконок
		local icons = (LazyVim and LazyVim.config and LazyVim.config.icons)
			or {
				diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = " " },
				git = { added = " ", modified = " ", removed = " " },
			}

		vim.o.laststatus = vim.g.lualine_laststatus

		local opts = {
			options = {
				theme = "auto",
				globalstatus = vim.o.laststatus == 3,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					-- Проверка наличия функций LazyVim
					(LazyVim and LazyVim.lualine and LazyVim.lualine.root_dir()) or { "filetype", icon_only = false },
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					(LazyVim and LazyVim.lualine and LazyVim.lualine.pretty_path()) or { "filename" },
				},
				lualine_x = {
					-- Проверка Snacks
					(Snacks and Snacks.profiler and Snacks.profiler.status()) or nil,
					{
						function()
							return require("noice").api.status.command.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.command.has()
						end,
						color = function()
							return Snacks and { fg = Snacks.util.color("Statement") } or { fg = "#ff00ff" }
						end,
					},
					{
						function()
							return require("noice").api.status.mode.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.mode.has()
						end,
						color = function()
							return Snacks and { fg = Snacks.util.color("Constant") } or { fg = "#00ffff" }
						end,
					},
					{
						function()
							return "  " .. require("dap").status()
						end,
						cond = function()
							return package.loaded["dap"] and require("dap").status() ~= ""
						end,
						color = function()
							return Snacks and { fg = Snacks.util.color("Debug") } or { fg = "#ff0000" }
						end,
					},
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = function()
							return Snacks and { fg = Snacks.util.color("Special") } or { fg = "#ffff00" }
						end,
					},
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return " " .. os.date("%R")
					end,
				},
			},
			extensions = { "neo-tree", "lazy", "fzf" },
		}

		-- Исправленная интеграция с Trouble
		if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				hl_group = "lualine_c_normal",
			})
			if symbols then
				table.insert(opts.sections.lualine_c, {
					function()
						return symbols.get()
					end,
					cond = function()
						return vim.b.trouble_lualine ~= false and symbols.has()
					end,
				})
			end
		end

		return opts
	end,
}

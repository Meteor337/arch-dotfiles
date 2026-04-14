return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- 1. Импорт цветов Tokyo Night (исправлено)
		local ok, tokyonight = pcall(require, "tokyonight.colors")
		local colors
		if ok then
			colors = tokyonight.setup()
		else
			-- Fallback цвета если тема Tokyo Night не установлена
			colors = {
				bg = "#1a1b26",
				bg_dark = "#16161e",
				bg_highlight = "#2c3e50",
				fg = "#c0caf5",
				comment = "#565f89",
				blue = "#7aa2f7",
				green = "#9ece6a",
				orange = "#ff9e64",
				red = "#f7768e",
				yellow = "#e0af68",
				warning = "#e0af68",
				info = "#7dcfff",
			}
		end

		-- 2. Маппинг цветов
		local p = {
			bg = colors.bg,
			bg_dark = colors.bg_dark,
			bg_float = colors.bg_highlight or colors.bg,
			fg = colors.fg,
			fg_dim = colors.comment,
			func = colors.blue,
			string = colors.green,
			class = colors.orange,
			error = colors.red,
			number = colors.yellow,
			diag_err = colors.red,
			diag_warn = colors.warning or colors.yellow,
			diag_info = colors.info or colors.blue,
		}

		-- 3. Кастомная тема (без скруглений)
		local custom_theme = {
			normal = {
				a = { bg = p.func, fg = p.bg, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			insert = {
				a = { bg = p.string, fg = p.bg_dark, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			visual = {
				a = { bg = p.class, fg = p.bg_dark, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			replace = {
				a = { bg = p.error, fg = p.bg, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			command = {
				a = { bg = p.number, fg = p.bg, gui = "bold" },
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			inactive = {
				a = { bg = p.bg_dark, fg = p.fg_dim, gui = "bold" },
				b = { bg = p.bg_dark, fg = p.fg_dim },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
		}

		-- 4. Настройка Lualine (прямые углы)
		require("lualine").setup({
			options = {
				theme = custom_theme,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" }, -- Убраны скругленные элементы
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			sections = {
				lualine_a = {
					{ "mode", right_padding = 2 },
				},
				lualine_b = {
					"branch",
					{ "diff", colored = true },
				},
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " " },
						diagnostics_color = {
							error = { fg = p.diag_err },
							warn = { fg = p.diag_warn },
							info = { fg = p.diag_info },
						},
					},
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = {
					{ "location", left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}

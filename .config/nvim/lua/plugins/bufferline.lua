return {
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
		},
		opts = {
			options = {
				-- Проверка на наличие Snacks для безопасного удаления буферов
				close_command = function(n)
					if _G.Snacks then
						Snacks.bufdelete(n)
					else
						vim.api.nvim_buf_delete(n, { force = false })
					end
				end,
				right_mouse_command = function(n)
					if _G.Snacks then
						Snacks.bufdelete(n)
					else
						vim.api.nvim_buf_delete(n, { force = false })
					end
				end,
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				diagnostics_indicator = function(_, _, diag)
					-- Безопасное получение иконок
					local icons = _G.LazyVim and LazyVim.config.icons.diagnostics or {}
					local ret = (diag.error and (icons.Error or " ") .. diag.error .. " " or "")
						.. (diag.warning and (icons.Warn or " ") .. diag.warning or "")
					return vim.trim(ret)
				end,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "left",
					},
					{
						filetype = "snacks_layout_box",
					},
				},
				get_element_icon = function(opts)
					return _G.LazyVim and LazyVim.config.icons.ft[opts.filetype]
				end,
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
			-- Исправлено: корректное обновление при работе с сессиями
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						pcall(function()
							if vim.api.nvim_get_vvar("vim_did_entering") ~= 1 then
								vim.cmd("redrawtabline")
							end
						end)
					end)
				end,
			})
		end,
	},
}

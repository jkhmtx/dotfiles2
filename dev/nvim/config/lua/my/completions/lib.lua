local M = {}

local blinkcmp = require("blink.cmp")

M.get_capabilities = function()
	return blinkcmp.get_lsp_capabilities()
end

M.setup = function()
	return blinkcmp.setup({
		cmdline = {
			enabled = true,
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
		keymap = {
			preset = "enter",
		},
		appearance = {
			-- sets the fallback highlight groups to nvim-cmp's highlight groups
			-- useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release, assuming themes add support
			use_nvim_cmp_as_default = false,
			-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},
		completion = {
			accept = {
				-- experimental auto-brackets support
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = true,
			},
		},
	})
end

return M

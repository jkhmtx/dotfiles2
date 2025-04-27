local M = {}

local blinkcmp = require("blink.cmp")

M.capabilities = blinkcmp.get_lsp_capabilities()

blinkcmp.setup({
	cmdline = {
		enabled = true,
		completion = {
			menu = {
				auto_show = true,
			},
		},
	},
})

return M

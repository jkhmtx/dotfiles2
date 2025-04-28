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
	})
end

return M

local buffers = require("my.buffers.lib")

-- Create an autocommand to set hidden=off when a buffer is opened
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*",
	callback = buffers.set_hidden_off,
})

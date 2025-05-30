local M = {}

local current_buffer_bfnr = 0

M.buf_restart_clients = function(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr or current_buffer_bfnr })
	vim.lsp.stop_client(clients, true)

	local timer = vim.uv.new_timer()

	timer:start(500, 0, function()
		for _, _client in ipairs(clients) do
			vim.schedule_wrap(function(client)
				vim.lsp.enable(client.name)

				vim.cmd(":noautocmd write")
				vim.cmd(":edit")
			end)(_client)
		end
	end)
end

return M

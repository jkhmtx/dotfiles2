local M = {}

M.find_files = function()
	require("telescope.builtin").find_files({ hidden = true })
end

M.live_grep = function()
	require("telescope.builtin").live_grep({
		additional_args = function(_)
			return { "--hidden" }
		end,
	})
end

M.resume_finder = function()
	require("telescope.builtin").resume()
end

M.find_buffers = function()
	require("telescope.builtin").buffers()
end

return M

local M = {}

--- @class FinderOpts
--- @field hidden? boolean

--- @class FindFilesOpts: FinderOpts
--- @field cwd? string

--- @param opts? FindFilesOpts
M.find_files = function(opts)
	opts = opts or {}
	opts.hidden = true

	require("telescope.builtin").find_files(opts)
end

--- @class LiveGrepOpts: FinderOpts
--- @field cwd? string
--- @field additional_args function | nil

--- @param opts? FinderOpts
M.live_grep = function(opts)
	opts = opts or {}

	--- @class LiveGrepOpts
	local live_grep_opts = vim.tbl_deep_extend("force", opts, {})
	if opts.hidden then
		live_grep_opts.additional_args = function(_)
			return { "--hidden" }
		end
	end

	require("telescope.builtin").live_grep(live_grep_opts)
end

M.resume_finder = function()
	require("telescope.builtin").resume()
end

M.find_buffers = function()
	require("telescope.builtin").buffers()
end

return M

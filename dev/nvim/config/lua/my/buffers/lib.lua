local M = {}

---@type table<string, boolean | nil>
local files_nohidden_map = {}

---@param args vim.api.keyset.create_autocmd.callback_args
M.set_hidden_off = function(args)
	local cached = files_nohidden_map[args.file]

	if cached ~= nil then
		return cached
	end

	local function is_git_ignored(file)
		local handle = io.popen("git check-ignore -q " .. file)

		if not handle then
			return false
		end

		local result = handle:close()
		return result == true
	end

	local cwd = vim.fn.getcwd()

	-- Check if the file is within the CWD and not gitignored
	local hidden = args.file:match("^" .. cwd) and not is_git_ignored(args.file)

	vim.opt_local.hidden = hidden
	files_nohidden_map[args.file] = hidden
end

return M

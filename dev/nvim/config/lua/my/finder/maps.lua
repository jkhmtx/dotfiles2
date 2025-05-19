vim.keymap.set("n", "<leader>ff", function()
	require("my.finder.lib").find_files()
end, { desc = "(F)ind (F)iles" })

vim.keymap.set("n", "<leader>fcf", function()
	local cwd = vim.fn.expand("%:p:h")

	require("my.finder.lib").find_files({ cwd = cwd })
end, { desc = "(F)ind (C)wd (F)iles" })

vim.keymap.set("n", "<leader>fg", function()
	require("my.finder.lib").live_grep()
end, { desc = "(F)ind (G)rep" })

vim.keymap.set("n", "<leader>fcg", function()
	local cwd = vim.fn.expand("%:p:h")

	require("my.finder.lib").live_grep({ cwd = cwd })
end, { desc = "(F)ind (C)wd (F)iles" })

vim.keymap.set("n", "<leader>fr", function()
	require("my.finder.lib").resume_finder()
end, { desc = "(R)esume (F)inder" })

local find_buffers_opts = {
	{ lhs = "<leader>fb", desc = "(F)ind (B)uffers" },
	{ lhs = "<leader>,", desc = "Find Buffers" },
}

for _, opts in ipairs(find_buffers_opts) do
	vim.keymap.set("n", opts.lhs, function()
		require("my.finder.lib").find_buffers()
	end, { desc = opts.desc })
end

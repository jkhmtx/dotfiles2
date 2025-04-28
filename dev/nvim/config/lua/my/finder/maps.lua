vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "(F)ind (F)iles" })

vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "(F)ind (G)rep" })

vim.keymap.set("n", "<leader>fr", function()
	require("telescope.builtin").resume()
end, { desc = "(R)esume (F)inder" })

local find_buffers_opts = {
	{ lhs = "<leader>fb", desc = "(F)ind (B)uffers" },
	{ lhs = "<leader>,", desc = "Find Buffers" },
}

for _, opts in ipairs(find_buffers_opts) do
	vim.keymap.set("n", opts.lhs, function()
		require("telescope.builtin").buffers()
	end, { desc = opts.desc })
end

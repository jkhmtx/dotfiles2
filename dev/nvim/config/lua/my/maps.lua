-- The best keymap ever
vim.keymap.set(
	"v",
	"<leader>p",
	'"_dP',
	{ desc = "Delete selected text into _ register and paste before cursor, i.e. replace the selected text" }
)

-- Moving selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves Line Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves Line Up" })

-- Clipboard
vim.keymap.set({ "v", "n" }, "<leader>mc", '"+y', { desc = "(m)ouse (c)opy" })
vim.keymap.set({ "v", "n" }, "<leader>mp", '"+p', { desc = "(m)ouse (p)aste" })

-- RegExp Magic mode
vim.keymap.set({ "n", "v" }, "/", "/\\v", { desc = "Make search very magic" })
vim.keymap.set("c", "%s/", "%smagic/", { desc = "Make replace very magic" })
vim.keymap.set("c", ">s/", ">smagic/", { desc = "Make replace very magic" })

-- CTRL+d/u niceness
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center the cursor when using CTRL+d" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center the cursor when using CTRL+u" })

-- Basically "middle scrolloff" all of these things
vim.keymap.set("n", "j", function()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = vim.api.nvim_win_get_height(0)
	local half = math.floor(lines / 2)

	local is_lower_than_middle = row >= half

	if is_lower_than_middle then
		vim.cmd("normal! zz")
	end

	vim.o.scrolloff = half

	vim.cmd("normal! j")
end, { desc = "Keep the cursor in the middle when scrolling down" })

vim.keymap.set("n", "k", function()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	local lines = vim.api.nvim_win_get_height(0)
	local half = math.floor(lines / 2)

	local is_higher_than_middle = row < half

	if is_higher_than_middle then
		vim.cmd("normal! zz")
	end

	vim.o.scrolloff = half

	vim.cmd("normal! k")
end, { desc = "Keep the cursor in the middle when scrolling up" })

vim.keymap.set("n", "n", "nzz", { desc = "Keep the cursor in the middle when searching next" })
vim.keymap.set("n", "N", "Nzz", { desc = "Keep the cursor in the middle when searching previous" })
vim.keymap.set("n", "G", "Gzz", { desc = "Keep the cursor in the middle when going to the bottom of the file" })

-- Buffers
vim.keymap.set("n", "H", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>b#<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "delete buffer" })

-- Dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Navigate window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Navigate window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Navigate window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Navigate window up" })

-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

local zz_group = vim.api.nvim_create_augroup("ZZ", { clear = true })

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinResized" }, {
	group = zz_group,
	callback = function()
		if vim.api.nvim_get_mode()["mode"] == "n" then
			vim.cmd("normal! zz")
		end
	end,
})

-- [[ Disable auto comment on enter ]]
-- See :help formatoptions
vim.api.nvim_create_autocmd("FileType", {
	desc = "remove formatoptions",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

local o = vim.opt --options

-- Scroll offset
o.scrolloff = 10
o.sidescrolloff = 10

-- Backing up/undoing
o.backup = true
o.writebackup = true

local state_dir = vim.fn.stdpath("state")
o.backupdir = state_dir .. "/backup"
o.undodir = state_dir .. "/undo"

-- Config
o.exrc = true
o.colorcolumn = "120"
o.autoread = true

-- Indentation/Sign-column numbers
vim.wo.signcolumn = "yes"
o.smartindent = true
vim.wo.relativenumber = true
vim.wo.nu = true

-- Misc
o.showmode = false

-- Search
o.inccommand = "split"
o.incsearch = true

-- Set highlight on search
o.hlsearch = true
-- Preview substitutions live, while you type
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Case insensitive searching UNLESS /C or capital letter is in search
o.ignorecase = true
o.smartcase = true
o.completeopt = "menuone,noselect,preview,noinsert"

-- Tabs
o.expandtab = true

local tabstop = 2

o.tabstop = tabstop
o.softtabstop = tabstop
o.shiftwidth = tabstop

-- Decrease update time
o.updatetime = 250
o.timeoutlen = 500

o.termguicolors = true

-- stops line wrapping from being confusing
o.breakindent = true

o.cpoptions:append("I")

-- Enable mouse mode
o.mouse = "a"

-- List
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Netrw
vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0

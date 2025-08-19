require("lze").load({
	"augment.vim",
	before = function()
		vim.g.augment_workspace_folders = {
			"/Users/jake/projects/sb/work",
		}
	end,
})

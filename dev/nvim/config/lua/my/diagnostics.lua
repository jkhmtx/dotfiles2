require("lze").load({
	"trouble.nvim",
	after = function()
		require("trouble").setup({})
	end,
})

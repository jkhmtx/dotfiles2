require("lze").load({
	"comment.nvim",
	after = function()
		require("Comment").setup()
	end,
})

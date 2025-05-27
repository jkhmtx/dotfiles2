require("lze").load({
	"nvim-colorizer.lua",
	after = function()
		require("colorizer").setup()
	end,
})

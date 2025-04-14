require("lze").load({
	{
		"telescope-fzf-native.nvim",
	},
	{
		"telescope.nvim",
		after = function()
			require("my.finder.maps")
			require("my.finder.config")
		end,
	},
})

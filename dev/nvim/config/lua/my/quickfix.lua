require("lze").load({
	{
		"quicker.nvim",
		ft = "qf",
		after = function()
			require("quicker").setup()
		end,
	},
})

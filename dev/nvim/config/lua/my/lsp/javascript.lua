return function(opts)
	require("lze").load({
		{
			"nvim-lspconfig",
			ft = opts.filetypes,
			dep_of = { "typescript-tools.nvim" },
		},
		{
			"typescript-tools.nvim",
			ft = opts.filetypes,
			after = function()
				require("typescript-tools").setup({})
			end,
		},
	})
end

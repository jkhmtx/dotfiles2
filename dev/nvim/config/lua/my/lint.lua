local linters_by_ft = {
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	terraform = { "tflint" },
}

require("lze").load({
	{
		"nvim-lint",
		ft = vim.tbl_keys(linters_by_ft),
		after = function(_)
			require("lint").linters_by_ft = linters_by_ft

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
})

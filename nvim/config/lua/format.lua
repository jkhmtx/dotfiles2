local formatters_by_ft = {
	lua = { "stylua" },
	nix = { "alejandra" },
	sh = { "shfmt" },
	toml = { "taplo", command = "taplo format -" },
	-- go = { "gofmt", "golint" },
	-- templ = { "templ" },
	-- Conform will run multiple formatters sequentially
	-- python = { "isort", "black" },
	-- Use a sub-list to run only the first available formatter
	-- javascript = { { "prettierd", "prettier" } },
}

require("lze").load({
	{
		"conform.nvim",
		ft = vim.tbl_keys(formatters_by_ft),
		after = function(plugin)
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = formatters_by_ft,
			})
			local autoformatting = vim.api.nvim_create_augroup("AutoFormatting", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				group = autoformatting,
				callback = function()
					conform.format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					})
				end,
			})

			vim.keymap.set({ "n", "v" }, "<leader>FF", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "[F]ormat [F]ile" })
		end,
	},
})

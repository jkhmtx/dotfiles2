local terraform = { "terraform", command = "terraform fmt -" }
local prettier = { "prettier" }

local formatters_by_ft = {
	lua = { "stylua" },
	nix = { "alejandra" },
	sh = { "shfmt" },
	toml = { "taplo", command = "taplo format -" },
	terraform = terraform,
	tf = terraform,
	["terraform-vars"] = terraform,
	hyprlang = { "hyprlang-fmt" },

	javascript = prettier,
	typescript = prettier,
	javascriptreact = prettier,
	typescriptreact = prettier,
	css = prettier,
	scss = prettier,
	less = prettier,
	html = prettier,
	json = prettier,
	jsonc = prettier,
	yaml = prettier,
	markdown = prettier,
	["markdown.mdx"] = prettier,
	graphql = prettier,
	handlebars = prettier,

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
		after = function()
			local conform = require("conform")

			conform.setup({
				formatters = {
					["hyprlang-fmt"] = {
						command = "hyprlang-fmt",
						inherit = false,
					},
				},
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

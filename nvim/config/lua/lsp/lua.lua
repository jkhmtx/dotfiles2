vim.lsp.config["luals"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			formatters = {
				ignoreComments = true,
			},
			signatureHelp = { enabled = true },
			diagnostics = {
				globals = { "vim" },
				disable = { "missing-fields" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					-- '${3rd}/luv/library',
					unpack(vim.api.nvim_get_runtime_file("", true)),
				},
			},
			completion = {
				callSnippet = "Replace",
			},
			telemetry = { enabled = false },
		},
	},
}

vim.lsp.enable("luals")

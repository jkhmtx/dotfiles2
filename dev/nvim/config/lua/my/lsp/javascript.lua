return function(opts)
	-- local tsserver_options = {
	-- 	maxTsServerMemory = 32768,
	-- 	updateImportsOnFileMove = { enabled = "always" },
	-- 	suggest = {
	-- 		completeFunctionCalls = true,
	-- 	},
	-- 	inlayHints = {
	-- 		enumMemberValues = { enabled = true },
	-- 		functionLikeReturnTypes = { enabled = true },
	-- 		parameterNames = { enabled = "literals" },
	-- 		parameterTypes = { enabled = true },
	-- 		propertyDeclarationTypes = { enabled = true },
	-- 		variableTypes = { enabled = false },
	-- 	},
	-- }

	vim.lsp.config["tsgo"] = {
		cmd = { "tsgo", "--lsp", "--stdio" },
		filetypes = opts.filetypes,
		settings = {
			complete_function_calls = true,
			-- vtsls = {
			-- 	enableMoveToFileCodeAction = true,
			-- 	autoUseWorkspaceTsdk = true,
			-- 	experimental = {
			-- 		maxInlayHintLength = 30,
			-- 		completion = {
			-- 			enableServerSideFuzzyMatch = true,
			-- 		},
			-- 	},
			-- },
			-- typescript = tsserver_options,
			-- javascript = tsserver_options,
		},
		root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	}

	vim.lsp.enable("tsgo")
end

return function(opts)
	local tsserver_options = {
		maxTsServerMemory = 32768,
		updateImportsOnFileMove = { enabled = "always" },
		suggest = {
			completeFunctionCalls = true,
		},
		inlayHints = {
			enumMemberValues = { enabled = true },
			functionLikeReturnTypes = { enabled = true },
			parameterNames = { enabled = "literals" },
			parameterTypes = { enabled = true },
			propertyDeclarationTypes = { enabled = true },
			variableTypes = { enabled = false },
		},
	}

	vim.lsp.config["vtsls"] = {
		cmd = { "vtsls", "--stdio" },
		filetypes = opts.filetypes,
		root_markers = { "package.json", "jsconfig.json", "tsconfig.json", ".git" },
		settings = {
			complete_function_calls = true,
			vtsls = {
				enableMoveToFileCodeAction = true,
				autoUseWorkspaceTsdk = true,
				experimental = {
					maxInlayHintLength = 30,
					completion = {
						enableServerSideFuzzyMatch = true,
					},
				},
			},
			typescript = tsserver_options,
			javascript = tsserver_options,
		},
		capabilities = opts.capabilities or nil,
	}

	vim.lsp.enable("vtsls")
end

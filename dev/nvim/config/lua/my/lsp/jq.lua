return function(opts)
	vim.lsp.config["jq-lsp"] = {
		cmd = { "jq-lsp" },
		filetypes = opts.filetypes,
		root_markers = { ".git" },
		capabilities = opts.capabilities or nil,
	}

	vim.lsp.enable("jq-lsp")
end

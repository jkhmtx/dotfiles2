return function(opts)
	vim.lsp.config["terraform-ls"] = {
		cmd = { "terraform-ls", "serve" },
		filetypes = opts.filetypes,
		root_markers = { ".terraform", ".git" },
		capabilities = opts.capabilities or nil,
	}

	vim.lsp.enable("terraform-ls")
end

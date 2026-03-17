return function(opts)
	vim.lsp.config["rust-analyzer"] = {
		cmd = { "rust-analyzer" },
		filetypes = opts.filetypes,
		root_markers = { "Cargo.lock", "Cargo.toml", ".git" },
		settings = {
			["rust-analyzer"] = {
				check = {
					command = "clippy",
				},
			},
		},
		capabilities = opts.capabilities or nil,
	}

	vim.lsp.enable("rust-analyzer")
end

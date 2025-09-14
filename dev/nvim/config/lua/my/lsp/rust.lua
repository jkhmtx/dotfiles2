return function(opts)
	vim.lsp.config["rust-analyzer"] = {
		cmd = function(dispatchers, config)
			local directory_local_rust_analyzer = vim.fn.system("which rust-analyzer")

			directory_local_rust_analyzer = directory_local_rust_analyzer:gsub("%s+", "")

			-- Check if the command was successful
			local config_cmd = nil
			if vim.v.shell_error == 0 then
				vim.print(directory_local_rust_analyzer)
				config_cmd = directory_local_rust_analyzer
			else
				config_cmd = "rust-analyzer"
			end

			return vim.lsp.rpc.start({ config_cmd }, dispatchers, {
				cwd = config.cmd_cwd,
				env = config.cmd_env,
				detached = config.detached,
			})
		end,
		filetypes = opts.filetypes,
		root_markers = { "Cargo.lock", "Cargo.toml", ".git" },
		settings = {},
		capabilities = opts.capabilities or nil,
	}

	vim.lsp.enable("rust-analyzer")
end

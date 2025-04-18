vim.lsp.config["nixd"] = {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.lock", ".git" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.jakeh.options',
				},
				home_manager = {
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations.jakeh.options',
				},
			},
		},
	},
}

vim.lsp.enable("nixd")

local mod = function(tbl)
	local name = tbl[1]

	return vim.tbl_extend("force", {
		name,
		before = function()
			require(name)
		end,
	}, tbl)
end

require("lze").load({
	mod({
		"my.lsp.lua",
		ft = "lua",
	}),
	mod({
		"my.lsp.nix",
		ft = "nix",
	}),
	mod({
		"my.lsp.bash",
		ft = { "bash", "sh" },
	}),
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

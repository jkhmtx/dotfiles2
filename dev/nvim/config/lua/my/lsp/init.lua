--- @class my.lsp.LspConfigOpts
--- @field [1] string
--- @field ft string[]

--- @param opts my.lsp.LspConfigOpts
local lsp_config = function(opts)
	local name = opts[1]

	return vim.tbl_extend("force", {
		name,
		before = function()
			local lsp_modules_opts = {
				capabilities = require("my.completions").get_capabilities(),
				filetypes = opts.ft,
			}

			require(name)(lsp_modules_opts)
		end,
	}, opts)
end

require("lze").load({
	lsp_config({
		"my.lsp.bash",
		ft = { "bash", "sh" },
	}),
	lsp_config({
		"my.lsp.lua",
		ft = { "lua" },
	}),
	lsp_config({
		"my.lsp.nix",
		ft = { "nix" },
	}),
	lsp_config({
		"my.lsp.terraform",
		ft = { "terraform", "terraform-vars" },
	}),
	lsp_config({
		"my.lsp.javascript",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	}),
	lsp_config({
		"my.lsp.jq",
		ft = { "jq" },
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

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
		"lsp.lua",
		ft = "lua",
	}),
})

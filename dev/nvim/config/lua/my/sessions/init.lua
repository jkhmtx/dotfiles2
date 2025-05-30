require("lze").load({
	"persistence.nvim",
	event = "BufReadPre",
	after = function()
		require("persistence").setup()

		local file = vim.fn.expand("%")

		vim.schedule(function()
			require("persistence").load()

			vim.cmd(":edit " .. file)
		end)
	end,
})

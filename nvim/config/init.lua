require("opts")
require("maps")

require("lze").register_handlers(require("lzextras").lsp)

vim.cmd.colorscheme(nixCats("colorscheme"))

require("netrw")
require("format")
require("auto")

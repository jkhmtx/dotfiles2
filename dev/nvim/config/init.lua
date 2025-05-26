require("my.opts")
require("my.maps")

require("lze").register_handlers(require("lzextras").lsp)

vim.cmd.colorscheme(nixCats("colorscheme"))

require("my.netrw")
require("my.format")
require("my.lint")
require("my.lsp")
require("my.finder")
require("my.completions").setup()
require("my.quickfix")
require("my.surround")

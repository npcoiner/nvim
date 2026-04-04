local gh = function(x) return 'https://github.com/' .. x end
local cb = function(x) return 'https://codeberg.org/' .. x end
-- vim.pack.add({ gh('user/plugin1'), cb('user/plugin2') })
vim.pack.add({
	gh('nvim-treesitter/nvim-treesitter'),
	gh('neovim/nvim-lspconfig'),
})

-- options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.tabstop = 2 -- tabwidth
vim.opt.shiftwidth = 2 -- indentwidth
vim.opt.expandtab = true -- use spaces for tab (idk what this means tbh lol)
vim.opt.smartindent = true -- smart auto-indenting
vim.opt.autoindent = true -- copies indent of current line on newline

vim.opt.ignorecase = true -- ignore casing
vim.opt.smartcase = true -- don't ignore casing if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- shows search match as being typed

vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no term bell on error

vim.opt.encoding = "utf-8" -- default encoding

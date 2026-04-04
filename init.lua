local gh = function(x) return 'https://github.com/' .. x end
local cb = function(x) return 'https://codeberg.org/' .. x end
-- vim.pack.add({ gh('user/plugin1'), cb('user/plugin2') })
vim.pack.add({
	gh('nvim-treesitter/nvim-treesitter'),
	gh('neovim/nvim-lspconfig'),
})

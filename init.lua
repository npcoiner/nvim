local gh = function(x) return 'https://github.com/' .. x end
local cb = function(x) return 'https://codeberg.org/' .. x end
-- vim.pack.add({ gh('user/plugin1'), cb('user/plugin2') })
vim.pack.add({
	gh('nvim-treesitter/nvim-treesitter'),
	gh('neovim/nvim-lspconfig'),
})

--Much of this config is referencing a video from The Rad Lectures
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

-- keymap
vim.g.mapleader = " "

--better movement in wrapped text (https://old.reddit.com/r/neovim/comments/122scnj/changed_my_mapping_of_jk_into_gj_and_gk_to/)
vim.keymap.set({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

--cool alt movement for line selection.
vim.keymap.set({ "v" }, "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set({ "v" }, "<A-j>", ":m '>+1<CR>gv=gv")

--indent and reselect, default deselects and thus requires reselect for multiple indents
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

--CTRL + SHIFT + c = copy text to system clipboard. yank still goes to register
vim.keymap.set('v', '<C-S-c>', '"+y', { noremap = true })

--highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserConfig", {clear = true}),
  callback = function()
    vim.hl.on_yank()
  end,
})

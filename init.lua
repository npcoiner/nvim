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

-- plugins
--
local gh = function(x) return 'https://github.com/' .. x end
local cb = function(x) return 'https://codeberg.org/' .. x end

-- vim.pack.add({ gh('user/plugin1'), cb('user/plugin2') })
vim.pack.add({
  {
    src = gh('nvim-treesitter/nvim-treesitter'),
    branch = "main",
    build = ":TSUpdate",
  },
	gh('neovim/nvim-lspconfig'),
	gh('nvim-tree/nvim-tree.lua'),
  gh('ibhagwan/fzf-lua'),
  gh('echasnovski/mini.nvim'),
  gh('lewis6991/gitsigns.nvim'),
})

--nvim-tree
require("nvim-tree").setup({
  view = {
    width = 35,
  },
  filters = {
    dotfiles = false, --show dotfiles
  },
  renderer = {
    group_empty = true,
  },
})
vim.keymap.set("n", "<leader>ex", function()
  require("nvim-tree.api").tree.toggle()
end, {desc = "Toggle NvimTree"})

--fzf-lua
require("fzf-lua").setup({})
vim.keymap.set("n", "<leader>ff", function()
  require("fzf-lua").files()
end, {desc = "FZF files"})
vim.keymap.set("n", "<leader>fg", function()
  require("fzf-lua").live_grep()
end, {desc = "Live Grep"})

--mini.nvim
require("mini.comment").setup({})
require("mini.trailspace").setup({})
require("mini.icons").setup({})
require("mini.indentscope").setup({})

--git signs
require("gitsigns").setup({})

--nvim-treesitter
local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"go",
    "lua",
    "python",
    "typescript",
    "vue",
		"html",
		"css",
		"javascript",
    "bash",
    "c_sharp",
    "zig",
    "rust",
    "c",
		"json",
		"svelte",
	}

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

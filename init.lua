--Much of this config is referencing a video from The Rad Lectures
-- options

--allows us to use nvimrc/nvim.lua/.exrc files in current directory
vim.opt.exrc = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = true
vim.opt.scrolloff = 100
vim.opt.sidescrolloff = 10

vim.opt.tabstop = 2        -- tabwidth
vim.opt.shiftwidth = 2     -- indentwidth
vim.opt.expandtab = true   -- use spaces for tab (idk what this means tbh lol)
vim.opt.smartindent = true -- smart auto-indenting
vim.opt.autoindent = true  -- copies indent of current line on newline

vim.opt.ignorecase = true  -- ignore casing
vim.opt.smartcase = true   -- don't ignore casing if uppercase in string
vim.opt.hlsearch = true    -- highlight search matches
vim.opt.incsearch = true   -- shows search match as being typed

vim.opt.hidden = true      -- allow hidden buffers
vim.opt.errorbells = false -- no term bell on error

vim.opt.encoding = "utf-8" -- default encoding

vim.opt.termguicolors = true
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

--<leader> cwd to copy cwd to clipboard
vim.keymap.set('n', '<leader>cwd', ":let @+ = expand('%:p:h')<CR>", { desc = "Copy directory to clipboard" })
--highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserConfig", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Normal mode window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'focus left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'focus upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'focus right window' })

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
  gh('mason-org/mason.nvim'),
  gh('mason-org/mason-lspconfig.nvim'),
  gh('stevearc/conform.nvim'),
  gh('mfussenegger/nvim-lint'),
  gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
  gh('nvim-lua/plenary.nvim'),
  gh('milanglacier/minuet-ai.nvim'),
  gh('seblyng/roslyn.nvim'),
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
end, { desc = "Toggle NvimTree" })

--fzf-lua
require("fzf-lua").setup({})
vim.keymap.set("n", "<leader>ff", function()
  require("fzf-lua").files()
end, { desc = "FZF files" })
vim.keymap.set("n", "<leader>fg", function()
  require("fzf-lua").live_grep()
end, { desc = "Live Grep" })

--mini.nvim
require("mini.comment").setup({})
require("mini.trailspace").setup({})
require("mini.icons").setup({})
require("mini.indentscope").setup({})
require("mini.completion").setup({})
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-y>' or '<Tab>'
end, { expr = true, replace_keycodes = true })
vim.opt.completeopt = "menu,menuone,noinsert" --don't write any completions until either Enter or Tab
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

--minuet ai
require("minuet").setup({
  provider = 'openai_compatible',
  n_completions = 1,
  context_window = 2048,
  provider_options = {
    openai_compatible = {
      api_key = 'TERM',
      name = 'Ollama',
      end_point = 'http://localhost:11434/v1/chat/completions',
      model = 'gemma4:e4b', -- must actually run `ollama run gemma4:e4b`
      optional = {
        max_tokens = 124,
        top_p = 0.9,
      },
    },
  },
  -- lsp = {
  --   enabled_ft = { '*' },
  -- },
  virtualtext = {
    auto_trigger_ft = { '*' },
    keymap = { --accept_line should be with Enter
      accept_line = '<CR>',
    },
  },
})
--mason + mason-lspconfig
require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})
require("mason-lspconfig").setup({})
-- lsp
vim.keymap.set("n", "<leader>q", function()
  vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diag list" })
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})

--mason-tool-installer
require('mason-tool-installer').setup({
  ensure_installed = {
    'prettier',
    'eslint_d',
    'csharpier',
  },
})

--formatter
require('conform').setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    cs = { "csharpier" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

--linter
require('lint').linters_by_ft = {
  javascript = { 'eslint_d' }
}

--Roslyn.nvim for C# projects. Need to make a .nvim.lua file with the vim.g.roslyn_target
--set to the absolute path of the solution we want to use.
-- UNITY + NEOVIM QUICK SETUP REMINDERS
-- 1. FIX NEOVIM SERVER CONNECTION (Exit Code 2 / PATH issues):
--    Inside the Unity Editor's Neovim plugin settings:
--    * Environments Box: $PATH
--    * Arguments Box: Use the default generated string
--    * Jump Template: Change to "Drop to file and jump to position"
-- 2. SILENCE UNITY C# WARNINGS (e.g., "Unused LateUpdate"):
--    * Download 'Microsoft.Unity.Analyzers.dll
--    * In Unity Editor: Neovim -> Settings -> Browse to add custom analyzer .dll
--    * CRITICAL: Complete refresh/reload the Unity project (clicking "Regenerate" is a trap)
vim.lsp.config("roslyn", {
  on_attach = function()
    print("Roslyn server successfully attached!")
  end,
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

require("roslyn").setup({
  lock_target = true,
  silent = true,
  choose_target = function(targets)
    if vim.g.roslyn_target then
      return vim.iter(targets):find(function(item)
        return string.find(item, vim.g.roslyn_target, 1, true)
      end)
    end
    print("Couldn't find target :(")
    return nil
  end,
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition) -- Go to definition
vim.keymap.set('n', 'K', vim.lsp.buf.hover)       -- Hover

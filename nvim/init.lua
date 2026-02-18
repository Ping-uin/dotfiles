-- OPTIONS
vim.o.number = true
vim.o.signcolumn = "yes" -- bar for icons on the left
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.swapfile = false
-- vim.o.winborder = "rounded" -- more distinguishable ctrl + k window
vim.o.scrolloff = 5         -- window moves down if cursor is x lines above upper/bottom line
vim.o.sidescrolloff = 5
vim.o.incsearch = true
vim.o.ignorecase = true
-- vim.o.colorcolumn = "120" -- vertical bar for code length
vim.o.showmatch = true
vim.o.cursorline = true   -- show cursor position
-- vim.o.shell = "wezterm"	-- BUG: This opens wezterm as a external window not in buffer
vim.o.updatetime = 250
vim.o.undofile = true
-- HOTKEYS
vim.g.mapleader = " "                                       -- spacebar as leader key
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>') -- [if changes -> save] + reload config
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')    -- copy to system clipboard
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>x', '"+d<CR>')    -- cut to system clipboard
-- open new windows/buffers/terminals
vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>i') -- vertical terminal split
vim.keymap.set('n', '<leader>th', ':below split | terminal<CR>i')  -- horizontal terminal split
vim.keymap.set('n', '<leader>vs', ':vsplit<CR>')             -- vertical split (no terminal)
vim.keymap.set('n', '<leader>hs', ':split<CR>')              -- horizontal split (no terminal)
-- terminal navigation
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')                  -- exit terminal mode with Esc
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')            -- navigate from terminal
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')
-- move between windows/buffers with ctrl + directional keys
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- PLUGINS
vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" }, -- TODO: maybe swap to neo-tree
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/folke/todo-comments.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- LSP Keybindings
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	end,
})

vim.cmd("set completeopt+=noselect")

require "mason".setup()
require "mason-lspconfig".setup({
	ensure_installed = { "lua_ls", "basedpyright", "sqlls", "ts_ls" }
})

require "mini.pick".setup()
require "lualine".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "lua", "javascript", "python", "rust",
		"c", "cpp", "julia", "json", "yaml", "markdown", "sql", "typescript",
	},
	highlight = { enable = true }
})

require "oil".setup({
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = true,
		-- This function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			local m = name:match("^%.")
			return m ~= nil
		end,
	}
})

require "todo-comments".setup()

-- PLUGIN SPECIFIC HOTKEYS
vim.keymap.set('n', '<leader>ff', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>n', ":Oil<CR>")
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

-- LSP enable (without mason)
-- vim.lsp.enable({ "lua_ls", "basedpyright", "sqlls" })

-- GRAPHICS
require "kanagawa".setup()
vim.cmd("colorscheme kanagawa")

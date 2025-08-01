-- OPTIONS
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.winborder = "rounded"

-- HOTKEYS
vim.g.mapleader = " "                                       -- spacebar as leader key

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>') -- [if changes -> save] + reload config
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>') -- copy to system clipboard
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>x', '"+d<CR>') -- cut to system clipboard

-- PLUGINS
vim.pack.add({
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" }, -- TODO: maybe swap to neo-tree
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/folke/todo-comments.nvim" },

})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.cmd("set completeopt+=noselect")

require "mini.pick".setup()
require "nvim-treesitter.configs".setup({
	ensure_installed = { "javascript" },
	highlight = { enable = true }
})
require "oil".setup()
require "todo-comments".setup()

-- PLUGIN SPECIFIC HOTKEYS
vim.keymap.set('n', '<leader>ff', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")
vim.keymap.set('n', '<leader>n', ":Oil<CR>")
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.lsp.enable({ "lua_ls" })

-- GRAPHICS
require "kanagawa".setup({ transparent = true })
vim.cmd("colorscheme kanagawa")

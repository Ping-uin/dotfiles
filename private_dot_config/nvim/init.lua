vim.o.number = true
vim.o.tabstop = 4
vim.o.swapfile = false

-- SPACE as leader key
vim.g.mapleader = " "

-- 'n' -> normal
-- 'i' -> insert
-- 'v' -> visual
-- 'c' -> command
-- 'x' -> visual-block
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')	-- [if changes -> save] + reload config
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.keymap.set({ 'n', 'v', 'x'}, '<leader>y', '"+y<CR>')	-- copy to system clipboard
vim.keymap.set({ 'n', 'v', 'x'}, '<leader>x', '"+d<CR>')	-- cut to system clipboard

vim.pack.add({
		{src = "https://github.com/rebelot/kanagawa.nvim" },
		{src = "https://github.com/stevearc/oil.nvim" },
		{src = "https://github.com/echasnovski/mini.pick" },
		{src = "https://github.com/nvim-treesitter/nvim-treesitter" },
		{src = "https://github.com/neovim/nvim-lspconfig" },
		

})

vim.lsp.enable({"lua_ls"})
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.cmd("colorscheme kanagawa")

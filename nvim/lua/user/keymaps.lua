-- ~/.config/nvim/lua/user/keymaps.lua

-- Shorten function name
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap('n', '<leader>o', ':update<CR> :source<CR>') -- [if changes -> save] + reload config
keymap('n', '<leader>w', ':write<CR>')
keymap('n', '<leader>q', ':quit<CR>')
keymap({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')    -- copy to system clipboard
keymap({ 'n', 'v', 'x' }, '<leader>x', '"+d<CR>')    -- cut to system clipboard
-- open new windows/buffers/terminals
keymap('n', '<leader>tv', ':vsplit | terminal<CR>i') -- vertical terminal split
keymap('n', '<leader>th', ':below split | terminal<CR>i')  -- horizontal terminal split
keymap('n', '<leader>vs', ':vsplit<CR>')             -- vertical split (no terminal)
keymap('n', '<leader>hs', ':split<CR>')              -- horizontal split (no terminal)
-- terminal navigation
keymap('t', '<Esc>', '<C-\\><C-n>')                  -- exit terminal mode with Esc
keymap('t', '<C-h>', '<C-\\><C-n><C-w>h')            -- navigate from terminal
keymap('t', '<C-j>', '<C-\\><C-n><C-w>j')
keymap('t', '<C-k>', '<C-\\><C-n><C-w>k')
keymap('t', '<C-l>', '<C-\\><C-n><C-w>l')
-- move between windows/buffers with ctrl + directional keys
keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')


-- OPTIONS
vim.o.number = true
vim.o.signcolumn = "yes" -- bar for icons on the left
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.winborder = "rounded" -- more distinguishable ctrl + k window
vim.o.scrolloff = 5         -- window moves down if cursor is x lines above upper/bottom line
vim.o.sidescrolloff = 5
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.colorcolumn = "120" -- vertical bar for code length
vim.o.showmatch = true
vim.o.cursorline = true   -- show cursor position

-- set wezterm as default terminal 
-- vim.o.shell = "wezterm"	-- BUG: This opens wezterm as a external window not in buffer

-- HOTKEYS
vim.g.mapleader = " "                                       -- spacebar as leader key

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>') -- [if changes -> save] + reload config
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>') -- copy to system clipboard
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>x', '"+d<CR>') -- cut to system clipboard

-- open new windows/buffers/terminals
vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>i') -- vertical terminal split
vim.keymap.set('n', '<leader>th', ':split | terminal<CR>i')  -- horizontal terminal split
vim.keymap.set('n', '<leader>vs', ':vsplit<CR>')            -- vertical split (no terminal)
vim.keymap.set('n', '<leader>hs', ':split<CR>')             -- horizontal split (no terminal)

-- terminal navigation
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')       -- exit terminal mode with Esc
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h') -- navigate from terminal
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
	ensure_installed = { "lua", "javascript", "python", "rust",
		"c", "cpp", "julia", "json", "yaml", "markdown"
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
vim.lsp.enable({ "lua_ls" })

-- GRAPHICS
require "kanagawa".setup({ transparent = true })
vim.cmd("colorscheme kanagawa")

-- CUSTOM START SCREEN
local function create_start_screen()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'startscreen')
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    
    local ascii_art = {
        "⡆⠀⠀⠀⠀⠀⠀⠀⠐⠒⠒⠲⠿⣿⣯⣭⣍⠉⠉⠉⠉⠉⠁⢲⣦⢮⡐⠊⠉⢱⣮⠀⠈⠃⢔⣢⣼⣿⣷⡦⠾⠦⠲⣶⣶⣉⣶⣶⣶⣶",
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣶⣤⣤⣍⣙⠻⢿⣿⣦⣄⡀⠀⠘⣿⡻⣿⣿⡟⠛⠙⠀⢀⣴⣿⡿⠟⠉⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿",
        "⡇⠀⠀⠀⠀⠀⠀⠈⠉⠛⠋⠉⠀⠀⠀⠀⠈⠑⠨⡙⠿⣿⣶⣄⣿⣷⣿⠀⣮⠀⡀⢰⣿⡿⠋⠀⠀⠀⠀⠀⢀⠀⠀⠀⢿⣿⣿⣿⣿⣿",
        "⡇⠀⠀⢀⠔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠳⣬⡻⢿⣿⣿⠃⣀⡼⠷⡽⣿⡟⠀⢀⡀⠀⢠⣥⣴⣶⣶⣦⣄⣿⣿⣿⣿⣿⣿",
        "⡇⠀⣰⡟⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢷⣽⣿⣜⢿⡇⠀⢰⡟⢀⠖⠁⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⡇⣰⡿⢡⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠈⠋⢻⣷⣕⢠⡿⠑⠁⠀⠀⠀⠀⢀⣀⡈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿",
        "⢹⣿⢱⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡌⡠⠁⠀⢀⣤⣶⣿⣿⣿⣿⣿⣶⣍⠻⣿⢃⣶⣿⣿⣷⣄⠀⠈⠙⠿⣗⡀⠙⢿⣿⣿⣿⣿⣿⣿",
        "⢻⡧⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢰⠃⠀⠀⠉⠛⠻⢿⣿⣿⣿⣿⣿⣿⣷⣤⣾⣿⣿⣿⡿⠟⠃⠀⠀⠀⠈⠻⣷⢄⠙⢿⣿⣿⣿⣿",
        "⠸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡑⠄⠉⠻⢿⣿",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⣽⣿⣿⣿⡀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠄⠀⡀⠀⠉",
        "⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠓⠐⠒⣸⣄⣠⠀⣼⣿⣿⣿⣿⣴⡇⠑⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠄⠀",
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣿⣷⣶⣶⣦⣰⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢸⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂",
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠻⠿⠿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀",
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣉⡀⠀⠀⠀⢠⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠑⠦⣤⣑⠄⠀",
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⣴⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠂",
        "⡡⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⠟⠉⠀⠉⠀⠀⠙⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⡇⠀⠈⠙⠲⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⠛⠁⠀⠀⢤⣬⣤⠀⠀⣈⠍⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⡇⠀⠀⠀⠀⠀⠀⠉⠑⠲⢤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣿⣷⣦⠀⠈⠉⠈⠀⠐⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠳⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣷⣶⣾⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⢦⣄⡀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠢⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⢹⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣶",
        "⢸⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⢆⣠⣴⣾⠿⠟⠛⢛⣿⣿",
        "⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢄⠀⠀⠀⠀⠀⠀⡠⣶⡿⣫⠾⠛⠉⢁⣀⣤⣴⣶⣿⣿⠿",
    }
    
    local menu_text = {
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "The Black Rose shall bloom once more",
        "",
        "    Quick Actions:",
        "    <leader>ff - Find files",
        "    <leader>n  - File explorer (Oil)",
        "    <leader>h  - Help",
        "    <leader>q  - Quit",
        "",
    }
    
    -- Combine ASCII art and menu side by side
    local combined_content = {}
    local max_lines = math.max(#ascii_art, #menu_text)
    
    for i = 1, max_lines do
        local art_line = ascii_art[i] or ""
        local menu_line = menu_text[i] or ""
        -- Add spacing between art and menu (adjust spacing as needed)
        local combined_line = art_line .. "    " .. menu_line
        table.insert(combined_content, combined_line)
    end
    
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, combined_content)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    
    -- Center the content
    local win_height = vim.api.nvim_win_get_height(0)
    local content_height = #combined_content
    local padding = math.max(0, math.floor((win_height - content_height) / 2))
    
    for i = 1, padding do
        vim.api.nvim_buf_set_option(buf, 'modifiable', true)
        vim.api.nvim_buf_set_lines(buf, 0, 0, false, {""})
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    end
    
    vim.api.nvim_set_current_buf(buf)
    
    -- Set buffer-local keymaps for quick actions
    vim.keymap.set('n', 'q', ':quit<CR>', {buffer = buf, silent = true})
    vim.keymap.set('n', '<leader>ff', ':Pick files<CR>', {buffer = buf, silent = true})
    vim.keymap.set('n', '<leader>n', ':Oil<CR>', {buffer = buf, silent = true})
    vim.keymap.set('n', '<leader>h', ':Pick help<CR>', {buffer = buf, silent = true})
end

-- Show start screen when opening Neovim without arguments
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        -- Only show if no files were opened and it's the only window
        if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
            create_start_screen()
        end
    end,
})

-- Hide start screen when opening a file
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    callback = function()
        if vim.bo.filetype == 'startscreen' then
            vim.api.nvim_buf_delete(0, {force = true})
        end
    end,
})

-- ~/.config/nvim/lua/user/plugins.lua

-- 1. Plugins laden
vim.pack.add({
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
})

-- 2. Plugins konfigurieren

require("kanagawa").setup()
vim.cmd("colorscheme kanagawa")

require("mini.pick").setup()
require("lualine").setup()
require("todo-comments").setup()

require("oil").setup({
    view_options = {
        show_hidden = true,
        is_hidden_file = function(name, bufnr)
            return name:match("^%.") ~= nil
        end,
    }
})

-- Treesitter Config
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "c", "python", "rust" }, -- Halten Sie die Liste kurz
    highlight = { enable = true }
})

return {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
        -- configuration here or empty for defaults
    },
    name = "render-markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-web-devicons" },
    config = function()
        require("markdown").setup()
    end,
}

return {
    "scottmckendry/cyberdream.nvim",
    config = function()
        require("cyberdream").setup({
            -- Enable transparent background
            transparent = true,

            -- Enable italics comments
            italic_comments = true,

            -- Replace all fillchars with ' ' for the ultimate clean look
            hide_fillchars = false,

            -- Modern borderless telescope theme - also applies to fzf-lua
            borderless_pickers = false,

            -- Set terminal colors used in `:terminal`
            terminal_colors = true,

            -- Use caching to improve performance - WARNING: experimental feature - expect the unexpected!
            -- Early testing shows a 60-70% improvement in startup time. YMMV. Disables dynamic light/dark theme switching.
            cache = false, -- generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache

            variant = "auto",

            highlights = {
                -- Highlight groups to override, adding new groups is also possible
                -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

                -- Example:
                Comment = { fg = "#ebaeae", bg = "NONE", italic = true },
                LineNr = { fg = "#ebaeae", bg = "NONE", italic = false },
                CurSearch = { fg = "#d20f39", bg = "NONE" },
                IncSearch = { fg = "#64eb34", bg = "NONE" },
                Search = { fg = "#df8e1d", bg = "NONE" },
                Visual = { bg = "#666666" }
                -- CursorColumn = {  bg = "#ebaeae", italic = false },
                -- Cursor = {  bg = "#ebaeae", italic = false }

                -- Complete list can be found in `lua/cyberdream/theme.lua`
            },

            -- Disable or enable colorscheme extensions
            extensions = {
                telescope = true,
                notify = true,
                mini = true,
                dashboard = true,
                neogit = true,
                treesitter = true,
                whichkey = true,
                leap = false,
                indentblankline = false,
                lazy = true

            },
        })
    end
}

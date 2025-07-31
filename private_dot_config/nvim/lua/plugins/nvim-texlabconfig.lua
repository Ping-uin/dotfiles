return {
    "f3fora/nvim-texlabconfig",
    ft = "tex",
    build = "go build",
    opts = {},
    config = function()
        require('texlabconfig').setup()
    end,
    init = function()
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            pattern = { "*.tex", "*.bibtex" },
            group = vim.api.nvim_create_augroup("Texlabconfig", {}),
            desc = "Define buffer-local texlab mappings.",
            callback = function(ev)
                local map = require("config.utils").getMapFn { buffer = ev.buf }
                map("n", "<leader>lv", "<cmd>TexlabForward<cr>", { desc = "Texlab forward search"})
                map("n", "<leader>lb", "<cmd>TexlabBuild<cr>", { desc = "Texlab build"})
            end,
        })
    end,
}

-- Add to top of init.lua
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        print(vim.inspect(vim.v.errmsg))
    end
})
require "user"
require "concealercust"

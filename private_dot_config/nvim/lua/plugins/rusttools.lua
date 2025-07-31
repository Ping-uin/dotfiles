return {
  "mrcjkb/rustaceanvim",
  version = "^4", -- Recommended
  ft = { "rust" },
  config = function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- local rt = require "rustaceanvim"

    -- require("rustaceanvim").setup {
    vim.keymap.set("n", "<leader>rca", function()
      vim.cmd.RustLsp "codeAction" -- supports rust-analyzer's grouping
      -- or vim.lsp.buf.codeAction() if you don't want grouping.
    end, { silent = true, buffer = bufnr })
    -- vim.keymap.set("n", "<C-space>", rt., { buffer = bufnr }),
    -- }
  end,
}

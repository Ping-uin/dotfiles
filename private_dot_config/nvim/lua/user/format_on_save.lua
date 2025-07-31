-- vim.g.format_on_save = 1
--
vim.cmd [[
  command! EnableFormatOnSave lua vim.g.format_on_save = 1

  command! DisableFormatOnSave lua vim.g.format_on_save = 0

  command! Format lua require("conform").format()
  command! LspFormat lua vim.lsp.buf.format()
]]

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("format_on_save", { clear = true }),
--   pattern = "*",
--   desc = "Run LSP formatting on a file on save",
--   callback = function()
--     if vim.fn.exists ":Format" > 0 and vim.g.format_on_save == 1 then
--       vim.cmd.Format()
--     end
--   end,
-- })
--
-- Function to print current LSP settings
function Print_lsp_settings()
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    print("No active LSP clients.")
    return
  end
  for _, client in ipairs(clients) do
    print("Client: " .. client.name)
    print(vim.inspect(client.config.settings))
  end
end

-- Bind the function to a command
vim.cmd("command! LspPrintSettings lua Print_lsp_settings()")
-- Set autoread option
vim.opt.autoread = true

-- Define the autocmd for FocusGained, BufEnter, CursorHold, CursorHoldI events
vim.api.nvim_create_autocmd(
    {"FocusGained", "BufEnter", "CursorHold", "CursorHoldI"}, {
        callback = function()
            if vim.fn.mode() ~= 'c' then
                vim.cmd('checktime')
            end
        end
    }
)

-- Define the autocmd for FileChangedShellPost event
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    callback = function()
        vim.cmd('echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
    end
})

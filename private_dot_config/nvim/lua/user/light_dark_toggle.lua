-- vim.api.nvim_create_user_command("Light", function(_)
--   vim.cmd "colorscheme rose-pine-dawn"
-- end, { desc = "LSP: Format current buffer with LSP" })
--
-- vim.api.nvim_create_user_command("Dark", function(_)
--   vim.cmd "colorscheme rose-pine-moon"
-- end, { desc = "LSP: Format current buffer with LSP" })
--
-- vim.cmd [[
-- command! Dark lua colorscheme "rose-pine-moon"
-- command! Light lua colorscheme 'rose-pine-dawn'
-- ]]
-- vim.cmd [[
--   command! EnableFormatOnSave lua vim.g.format_on_save = 1
--   command! DisableFormatOnSave lua vim.g.format_on_save = 0
-- ]]

vim.cmd [[
command! Dark colorscheme rose-pine-moon
command! Light colorscheme rose-pine-dawn
command! On ObsidianNew
" command! LspLinesOff lua vim.diagnostic.config({ virtual_lines = false ,virtual_text=true})
" command! LspLinesOn lua vim.diagnostic.config({ virtual_lines = true, virtual_text=false })
" command! LspLinesToggle vim.diagnostic.config({ virtual_lines = false })
]]

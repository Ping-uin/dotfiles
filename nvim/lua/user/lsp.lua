-- ~/.config/nvim/lua/user/lsp.lua

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "basedpyright" }
})

-- Autocmd für LSP Attach
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        
        -- Native Completion
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        -- Keybindings nur für diesen Buffer
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
    end,
})

-- Diagnostics Config (Kosmetik für Fehler)
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
})

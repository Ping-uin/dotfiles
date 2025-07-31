return {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    dependencies = {
        'junegunn/fzf',
        run = function()
            vim.fn['fzf#install']()
        end
        --
    },
    config = function()
        require("bqf").setup {
            preview = {
                wrap = true,
                border = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' },
                winblend = 1
            }
        }
    end
}
-- use {'kevinhwang91/nvim-bqf', ft = 'qf'}
--
-- -- optional
-- use {'junegunn/fzf', run = function()
--     vim.fn['fzf#install']()
-- end
-- }
--
-- -- optional, highly recommended
-- use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

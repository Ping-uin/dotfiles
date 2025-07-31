return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "natecraddock/telescope-zf-native.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        cond = vim.fn.executable "cmake" == 2,
      },
    },
    config = function()
      local actions = require "telescope.actions"

      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-x>"] = actions.delete_buffer,
            },
          },
          file_ignore_patterns = {
            "05archive/",
            "node_modules",
            "yarn.lock",
            ".git",
            ".sl",
            "_build",
            ".next",
          },
          hidden = true,
          layout_strategy = "vertical",
          layout_config = {
            -- vertical = { width = 1.7 },
          },
        },
      }

      -- Enable telescope fzf native, if installed
        pcall(require("telescope").load_extension, "fzf")
        -- require("lazy").setup("my_plugins", { rocks = { enabled = false } })
        -- require("telescope").load_extension "zf-native"
    end,
  },
}

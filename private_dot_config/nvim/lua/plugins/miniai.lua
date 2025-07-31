return {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  dependencies = {  },
  opts = function()
    local nn = require "notebook-navigator"

    local opts = { custom_textobjects = { h = nn.miniai_spec } }
    return opts
  end,
}

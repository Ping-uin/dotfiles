return {
  "icewind/ltex-client.nvim",
  lazy = false,

  config = function()
    require("ltex-client").setup {}
  end,
}

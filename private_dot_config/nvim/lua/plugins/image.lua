-- local hostname = os.getenv "HOSTNAME"
if not string.find(vim.fn.hostname(), "node") then
  return {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
        },
      },
      max_width = 500,
      max_height = 500,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "noice", "" },
    },
  }
else
  return {}
end

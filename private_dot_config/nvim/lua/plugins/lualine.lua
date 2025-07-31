return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local harpoon = require "harpoon.mark"

      local function truncate_branch_name(branch)
        if not branch or branch == "" then
          return ""
        end

        -- Match the branch name to the specified format
        local _, _, ticket_number = string.find(branch, "skdillon/sko%-(%d+)%-")

        -- If the branch name matches the format, display sko-{ticket_number}, otherwise display the full branch name
        if ticket_number then
          return "sko-" .. ticket_number
        else
          return branch
        end
      end

      local function harpoon_component()
        local total_marks = harpoon.get_length()

        if total_marks == 0 then
          return ""
        end

        local current_mark = "—"

        local mark_idx = harpoon.get_current_index()
        if mark_idx ~= nil then
          current_mark = tostring(mark_idx)
        end

        return string.format("󱡅 %s/%d", current_mark, total_marks)
      end
      local function tde_battery()
        local command_output = vim.fn.system "cat /sys/class/power_supply/BAT0/uevent | grep POWER_SUPPLY_CAPACITY="
        local last_two_chars = command_output:sub(-3)
        -- print(last_two_chars)
        return string.format("󱊣%d", last_two_chars)
      end

      require("lualine").setup {
        options = {
          theme = "auto",
          globalstatus = false,
          component_separators = { left = "", right = "" },
          section_separators = { left = "|", right = "|" },
        },
        sections = {
          lualine_b = {
            { "branch", icon = "", fmt = truncate_branch_name },
            harpoon_component,
            -- tde_battery,
            "diff",
            "diagnostics",
          },
          lualine_c = {
            { "filename", path = 1 },
          },
          lualine_x = {
            "filetype",
          },
        },
      }
    end,
  },
}

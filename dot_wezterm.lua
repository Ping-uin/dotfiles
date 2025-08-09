-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30

-- KORREKTUR 1: Nur Wezterm-eigene Fensterdekoration ohne System-Titelleiste
config.window_decorations = 'NONE'

-- KORREKTUR 2: Mauszeiger immer anzeigen
config.hide_mouse_cursor_when_typing = false

-- initial geometry for new windows
config.initial_cols = 120
config.initial_rows = 35

config.adjust_window_size_when_changing_font_size = false

-- font and scheme stuff
config.font = wezterm.font({ family = 'Julia Mono' })
config.font_size = 12
config.color_scheme = 'lovelace'

-- always use zsh when using wez
config.default_prog = { "zsh" }

-- Status bar update interval
config.status_update_interval = 1000

-- Right status bar configuration
wezterm.on("update-right-status", function(window, pane)
  local cells = {}

  -- Get current working directory basename
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = ""
    if type(cwd_uri) == "userdata" then
      cwd = cwd_uri.file_path
    else
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find("/")
      if slash then
        cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end
    -- Get just the directory name, not full path
    local dir_name = cwd:match("([^/]+)/?$") or "~"
    table.insert(cells, { icon = wezterm.nerdfonts.md_folder, text = dir_name })
  end

  -- Get current time with icon
  local time = wezterm.strftime("%H:%M")
  table.insert(cells, { icon = wezterm.nerdfonts.md_clock, text = time })

  -- Battery info with appropriate icon and color coding
  for _, b in ipairs(wezterm.battery_info()) do
    local battery_pct = b.state_of_charge * 100
    local battery_icon = wezterm.nerdfonts.md_battery
    local battery_color = "#9bb3e0" -- soft blue from artwork

    if battery_pct < 20 then
      battery_icon = wezterm.nerdfonts.md_battery_10
      battery_color = "#e06b75" -- soft red accent
    elseif battery_pct < 50 then
      battery_icon = wezterm.nerdfonts.md_battery_50
      battery_color = "#e5c07b" -- warm yellow accent
    elseif battery_pct < 80 then
      battery_icon = wezterm.nerdfonts.md_battery_70
      battery_color = "#7fb3d3" -- light blue from artwork
    else
      battery_icon = wezterm.nerdfonts.md_battery_90
    end

    table.insert(cells, {
      icon = battery_icon,
      text = string.format("%.0f%%", battery_pct),
      color = battery_color
    })
  end

  -- Deep blue/purple gradient inspired by the artwork
  local colors = {
    "#1a1b3a", -- deepest night blue
    "#252a54", -- dark purple-blue
    "#2f3766", -- medium blue
    "#3a4578", -- lighter blue
    "#4a5490", -- lightest blue-purple
  }

  local text_fg = "#d4d8f0" -- soft white-blue like the figure
  local icon_fg = "#8fa3d4" -- muted blue like the flowers
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  local elements = {}
  local num_cells = 0

  function push(cell_data, is_last)
    local cell_no = num_cells + 1
    local bg_color = colors[math.min(cell_no, #colors)]

    -- Add separator arrow from previous cell
    if cell_no > 1 then
      table.insert(elements, { Foreground = { Color = bg_color } })
      table.insert(elements, { Background = { Color = colors[cell_no - 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end

    -- Add the cell content with icon
    table.insert(elements, { Background = { Color = bg_color } })
    table.insert(elements, { Foreground = { Color = cell_data.color or icon_fg } })
    table.insert(elements, { Text = " " .. cell_data.icon .. " " })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = cell_data.text .. " " })

    num_cells = num_cells + 1
  end

  for i, cell in ipairs(cells) do
    push(cell, i == #cells)
  end

  window:set_right_status(wezterm.format(elements))
end)

return config

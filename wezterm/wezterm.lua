-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()
-- config.window_background_opacity = 0.97
-- config.macos_window_background_blur = 30
config.window_decorations = 'RESIZE'
config.hide_mouse_cursor_when_typing = false
-- init size for new windows
config.initial_cols = 120
config.initial_rows = 35
config.adjust_window_size_when_changing_font_size = false
-- font and scheme stuff
config.font = wezterm.font({ family = 'Julia Mono' })
config.font_size = 12
config.color_scheme = 'Kanagawa (Gogh)'
-- always use zsh when using wez
config.default_prog = { "zsh" }

config.keys = {
	{
		key = 'E',
		mods = 'CTRL|SHIFT',
		action = wezterm.action.PromptInputLine {
			description = 'Enter new name for tab',
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		},
	},
}

wezterm.on("update-right-status", function(window, pane)
	-- kanagawa hexcodes
	local colors = {
		red = "#E82424", -- kanagawa red
		orange = "#FF9E3B", -- kanagawa orange
		green = "#98BB6C", -- kanagawa green
		blue = "#7E9CD8", -- kanagawa blue
		gray = "#727169", -- kanagawa gray (für Trenner)
	}

	local elements = {}

	-- battery info
	local battery_info = ""
	for _, b in ipairs(wezterm.battery_info()) do
		local battery_pct = b.state_of_charge * 100
		local battery_icon = "󰁹" -- nerd font
		local battery_color = colors.blue
		if battery_pct < 25 then
			battery_icon = "󰂎"
			battery_color = colors.red
		elseif battery_pct < 50 then
			battery_icon = "󰁿"
			battery_color = colors.orange
		elseif battery_pct < 75 then
			battery_icon = "󰂀"
			battery_color = colors.green
		end
		battery_info = battery_icon .. " " .. string.format("%.0f%%", battery_pct)

		table.insert(elements, { Foreground = { Color = battery_color } })
		table.insert(elements, { Text = battery_info })
	end

	-- weekday
	local weekday = wezterm.strftime("%a") -- Mon, Tue, Wed, Thu, Fri, Sat, Sun
	if #elements > 0 then
		table.insert(elements, { Foreground = { Color = colors.gray } })
		table.insert(elements, { Text = "  •  " })
	end
	table.insert(elements, { Foreground = { Color = colors.green } })
	table.insert(elements, { Text = "󰸗 " .. weekday }) -- calendar icon + weekday

	-- calendar week
	local week_number = wezterm.strftime("%V") -- week number
	table.insert(elements, { Foreground = { Color = colors.gray } })
	table.insert(elements, { Text = "  •  " })
	table.insert(elements, { Foreground = { Color = colors.orange } })
	table.insert(elements, { Text = "󰨲 " .. "KW" .. week_number }) -- week icon + week number

	-- curr time
	local time = wezterm.strftime("%H:%M")
	table.insert(elements, { Foreground = { Color = colors.gray } })
	table.insert(elements, { Text = "  •  " })
	table.insert(elements, { Foreground = { Color = colors.red } })
	table.insert(elements, { Text = "󰥔 " .. time .. " " })

	window:set_right_status(wezterm.format(elements))
end)

return config

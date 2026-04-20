-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()
-- config.window_background_opacity = 0.97
-- config.macos_window_background_blur = 30
-- config.window_decorations = 'TITLE|RESIZE'
config.enable_wayland = true
config.hide_mouse_cursor_when_typing = false
-- init size for new windows
config.initial_cols = 120
config.initial_rows = 35
config.adjust_window_size_when_changing_font_size = false
-- font and scheme stuff
config.font = wezterm.font({ family = 'Julia Mono' })
config.font_size = 12
config.color_scheme = 'Whimsy'
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
    -- Charm.land inspirierte Farbpalette
    local colors = {
        pink   = "#F25D94", -- Typisches Charm-Pink (für Uhrzeit)
        purple = "#7D56F4", -- Charm-Lila (für vollen Akku)
        cyan   = "#00ADD8", -- Charm-Cyan (für Kalenderwoche)
        green  = "#04B575", -- Charm-Mint (für Wochentag)
        gray   = "#6B6B6B", -- Dezentes Grau (für Trenner)
        red    = "#E84033", -- Warnrot (für fast leeren Akku)
        orange = "#FF9400", -- Warnorange (für halben Akku)
    }

    local elements = {}

    -- Hilfsfunktionen für sauberen Code (DRY-Prinzip)
    local function add_text(color, text)
        table.insert(elements, { Foreground = { Color = color } })
        table.insert(elements, { Text = text })
    end

    local function add_separator()
        if #elements > 0 then
            add_text(colors.gray, "  •  ")
        end
    end

    -- Batterie
    for _, b in ipairs(wezterm.battery_info()) do
        local battery_pct = b.state_of_charge * 100
        local battery_icon = "󰁹"
        local battery_color = colors.purple -- Standardfarbe ist jetzt das Charm-Lila

        if battery_pct < 25 then
            battery_icon, battery_color = "󰂎", colors.red
        elseif battery_pct < 50 then
            battery_icon, battery_color = "󰁿", colors.orange
        elseif battery_pct < 75 then
            battery_icon, battery_color = "󰂀", colors.green
        end

        add_text(battery_color, string.format("%s %.0f%%", battery_icon, battery_pct))
    end

    -- Wochentag
    add_separator()
    add_text(colors.green, "󰸗 " .. wezterm.strftime("%a"))

    -- Kalenderwoche
    add_separator()
    add_text(colors.cyan, "󰨲 KW" .. wezterm.strftime("%V"))

    -- Uhrzeit
    add_separator()
    add_text(colors.pink, "󰥔 " .. wezterm.strftime("%H:%M") .. " ")

    window:set_right_status(wezterm.format(elements))
end)

return config

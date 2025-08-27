local wezterm = require("wezterm")
local action = wezterm.action

return {
	font = wezterm.font("Maple Mono NL"),
	font_rules = {
		{
			intensity = "Bold",
			font = wezterm.font({ family = "Maple Mono NL", weight = "Bold" }),
		},
	},
	harfbuzz_features = { "zero=1" },

	window_close_confirmation = "NeverPrompt",
	hide_tab_bar_if_only_one_tab = true,

	window_padding = {
		left = 3,
		top = 3,
		bottom = 0,
		right = 0,
	},

	keys = {
		{
			key = "d",
			mods = "ALT",
			action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "n",
			mods = "ALT",
			action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "h",
			mods = "ALT",
			action = action.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "ALT",
			action = action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "ALT",
			action = action.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "ALT",
			action = action.ActivatePaneDirection("Right"),
		},
		{
			key = "h",
			mods = "ALT|SHIFT",
			action = action.AdjustPaneSize({ "Left", 5 }),
		},
		{
			key = "j",
			mods = "ALT|SHIFT",
			action = action.AdjustPaneSize({ "Down", 1 }),
		},
		{
			key = "k",
			mods = "ALT|SHIFT",
			action = action.AdjustPaneSize({ "Up", 1 }),
		},
		{
			key = "l",
			mods = "ALT|SHIFT",
			action = action.AdjustPaneSize({ "Right", 5 }),
		},
		{
			key = "m",
			mods = "ALT",
			action = action.TogglePaneZoomState,
		},
	},

	colors = {
		foreground = "#dcd7ba",
		background = "#1f1f28",

		cursor_bg = "#c8c093",
		cursor_fg = "#000000",
		cursor_border = "#c8c093",

		selection_fg = "#c8c093",
		selection_bg = "#2d4f67",

		scrollbar_thumb = "#16161d",
		split = "#54546d",

		ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
		brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
		indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
	},
}

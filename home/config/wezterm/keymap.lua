local wezterm = require("wezterm")
local act = wezterm.action

local mod = {
	CS = "CTRL|SHIFT",
	CA = "CTRL|ALT",
	C = "CTRL",
	S = "SHIFT",
}

local keybind = function(mods, key, action)
	return { key = key, mods = mods, action = action }
end

local keys = {
	keybind(mod.CS, "c", act.CopyTo("ClipboardAndPrimarySelection")),
	keybind(mod.CS, "v", act.PasteFrom("Clipboard")),
	keybind(mod.CA, "c", act.CopyTo("PrimarySelection")),
	keybind(mod.CA, "v", act.PasteFrom("PrimarySelection")),

	keybind(mod.CS, "+", act.IncreaseFontSize),
	keybind(mod.CS, "_", act.DecreaseFontSize),
	keybind(mod.CS, "f", act.Search("CurrentSelectionOrEmptyString")),
	keybind(mod.CS, "t", act.SpawnTab("CurrentPaneDomain")),
	keybind(mod.CS, "w", act.CloseCurrentTab({ confirm = true })),
	keybind(mod.CS, "PageUp", act.ScrollByPage(-0.5)),
	keybind(mod.CS, "PageDown", act.ScrollByPage(0.5)),

	keybind(mod.CS, " ", act.QuickSelect),
	keybind(mod.CS, "x", act.ActivateCopyMode),

	keybind(mod.S, "Enter", act.SendString("\x1b\r")),
}

return keys

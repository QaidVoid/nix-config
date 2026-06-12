local wezterm = require("wezterm")
local keys = require("keymap")

local function get_scheme(appearance)
  if appearance:find("Dark") then
  	return "tokyonight"
  else
  	return "tokyonight-day"
  end
end

-- Override WezTerm's built-in washed out theme
local tokyonight = {
  foreground = "#c0caf5",
  background = "#1a1b26",
  cursor_bg = "#c0caf5",
  cursor_fg = "#1a1b26",
  cursor_border = "#c0caf5",
  selection_fg = "#c0caf5",
  selection_bg = "#283457",
  scrollbar_thumb = "#292e42",
  split = "#7aa2f7",
  -- normal:  black red green yellow blue magenta cyan white
  ansi = { "#15161e", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },
  -- bright:
  brights = { "#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },
  -- Tokyo Night signature extras (orange / red)
  indexed = { [16] = "#ff9e64", [17] = "#db4b4b" },
  tab_bar = {
    background = "#16161e",
    active_tab = { bg_color = "#7aa2f7", fg_color = "#16161e" },
    inactive_tab = { bg_color = "#16161e", fg_color = "#565f89" },
    inactive_tab_hover = { bg_color = "#292e42", fg_color = "#c0caf5" },
    new_tab = { bg_color = "#16161e", fg_color = "#565f89" },
    new_tab_hover = { bg_color = "#292e42", fg_color = "#c0caf5" },
  },
}

local config = {
  enable_csi_u_key_encoding = false,
  enable_wayland = true,
  color_scheme = get_scheme(wezterm.gui.get_appearance()),
  color_schemes = { ["tokyonight"] = tokyonight },
  adjust_window_size_when_changing_font_size = false,
  font_size = 14,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  window_background_opacity = 0.9,
  hide_tab_bar_if_only_one_tab = true,
  disable_default_key_bindings = true,
  disable_default_mouse_bindings = true,
  keys = keys,
  mux_enable_ssh_agent = false,
}

return config

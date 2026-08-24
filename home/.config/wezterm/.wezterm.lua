local wezterm = require 'wezterm'

-- Use the config_builder if you are on a newer version of WezTerm
local config = wezterm.config_builder()

-- config.color_scheme = 'Tokyo Night Storm'
config.color_scheme = 'rose-pine'

config.keys = {
  -- Cmd + D for vertical split (panes left/right)
  -- Note: WezTerm calls this 'SplitHorizontal' because it splits along the horizontal axis
  {
    key = 'd',
    mods = 'SUPER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Cmd + Shift + D for horizontal split (panes top/bottom)
  -- Note: WezTerm calls this 'SplitVertical' because it splits along the vertical axis
  {
    key = 'd',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Move between split panes using Cmd + Option + Arrow Keys
  {
    key = 'LeftArrow',
    mods = 'SUPER|ALT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'SUPER|ALT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'SUPER|ALT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'SUPER|ALT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  -- Cmd + W to close the current pane instead of the whole tab
  {
    key = 'w',
    mods = 'SUPER',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  },
}

return config

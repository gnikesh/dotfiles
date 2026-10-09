local wezterm = require 'wezterm'

-- Use the config_builder if you are on a newer version of WezTerm
local config = wezterm.config_builder()

config.color_scheme = 'Kanagawa (Gogh)'
-- Check the battery status of your Mac
local batteries = wezterm.battery_info()

-- batteries[1] is your MacBook's internal battery
if batteries[1] and batteries[1].state == "Discharging" then
  -- WE ARE ON BATTERY POWER: Squeeze every drop
  config.max_fps = 30
  config.animation_fps = 1
  config.webgpu_power_preference = 'LowPower'
  
  -- Force solid background to save GPU cycles
  config.window_background_opacity = 1.0 
  config.macos_window_background_blur = 0
else
  -- WE ARE PLUGGED IN: Give me maximum performance
  config.max_fps = 120 -- (Or 60 depending on your screen)
  config.animation_fps = 60
  config.webgpu_power_preference = 'HighPerformance'
  
  -- You can safely re-enable transparency here if you like it
  config.window_background_opacity = 0.9 
end

config.keys = {
  -- Cmd + D for vertical split (panes left/right)
  -- Note: WezTerm calls this 'SplitHorizontal' because it splits along the horizontal axis
  -- Move between split panes using Cmd + [ and Cmd + ]
  {
    key = '[',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = ']',
    mods = 'SUPER',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
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

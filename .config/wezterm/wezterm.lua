local wezterm = require 'wezterm'
local act = wezterm.action

local function isViProcess(pane)
    -- get_foreground_process_name On Linux, macOS and Windows,
    -- the process can be queried to determine this path. Other operating systems
    -- (notably, FreeBSD and other unix systems) are not currently supported
    return (pane:get_foreground_process_name():find('n?vim') ~= nil
        or pane:get_foreground_process_name():find('tmux') ~= nil)
    -- return pane:get_title():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
    if isViProcess(pane) then
        window:perform_action(
        -- This should match the keybinds you set in Neovim.
            act.SendKey({ key = vim_direction, mods = 'CTRL' }),
            pane
        )
    else
        window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
    end
end

wezterm.on('ActivatePaneDirection-right', function(window, pane)
    conditionalActivatePane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
    conditionalActivatePane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
    conditionalActivatePane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
    conditionalActivatePane(window, pane, 'Down', 'j')
end)

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = 'Atom'
config.window_background_opacity = 0.95
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.window_padding = {
    left = 5,
    right = 5,
    top = 0,
    bottom = 0,
}
config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.6,
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'pwsh.exe', '-l' }
    config.font = wezterm.font 'FiraCode NF'
end

if wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
    config.default_prog = { '/usr/bin/fish', '-l' }
    config.font = wezterm.font 'Fira Code'
end

config.font_size = 11.0

config.leader = { key = 'm', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    { key = 'h', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-left') },
    { key = 'j', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-down') },
    { key = 'k', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-up') },
    { key = 'l', mods = 'CTRL', action = act.EmitEvent('ActivatePaneDirection-right') },

    {
        key = 'l',
        mods = 'LEADER|CTRL',
        action = act.SendKey { key = 'L', mods = 'CTRL' },
    },
    {
        key = 'v',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'p',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ActivateCommandPalette,
    },

    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },

    {
        key = 'LeftArrow',
        mods = 'LEADER',
        action = act.AdjustPaneSize { 'Left', 5 },
    },
    {
        key = 'DownArrow',
        mods = 'LEADER',
        action = act.AdjustPaneSize { 'Down', 5 },
    },
    { key = 'UpArrow', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
    {
        key = 'RightArrow',
        mods = 'LEADER',
        action = act.AdjustPaneSize { 'Right', 5 },
    },

    {
        key = 'e',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    {
        key = 'w',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentTab { confirm = true },
    },
    {
        key = 'c',
        mods = 'LEADER',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
}

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = act.ActivateTab(i - 1),
    })
end

return config

local wezterm = require 'wezterm'
local act = wezterm.action

return {
  keys = {
    -- Smart Ctrl+C (your working config)
    {
      key = 'c',
      mods = 'CTRL',
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ''
        if has_selection then
          window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
          window:perform_action(act.ClearSelection, pane)
        else
          window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
        end
      end),
    },
    
    -- Ctrl+V to paste
    {
      key = 'v',
      mods = 'CTRL',
      action = act.PasteFrom 'Clipboard',
    },
    
    -- (Optional) Keep Ctrl+Shift+V working as well
    {
      key = 'v',
      mods = 'CTRL|SHIFT',
      action = act.PasteFrom 'Clipboard',
    },
  },
}

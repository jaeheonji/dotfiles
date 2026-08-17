local M = {}

-- All captures land in $HOME/Pictures. $HOME and the timestamp are expanded by
-- /bin/sh (Hyprland spawns exec_cmd via /bin/sh, never the login shell), so this
-- is correct even though the interactive shell is nushell.
local DIR = '"$HOME/Pictures"'
local FILE = '"$HOME/Pictures/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"'

-- Run `grim <args> <file>`, ensuring the directory exists first.
---@param args string grim arguments preceding the output file
local function capture(args)
  hl.exec_cmd("mkdir -p " .. DIR .. " && grim " .. args .. " " .. FILE)
end

---Capture a free-hand region selected with slurp. Cancelling slurp (Esc)
---aborts without writing a file.
---@return function
function M.region()
  return function()
    -- g=$(slurp): a cancelled selection exits non-zero and short-circuits the
    -- && chain, so grim never runs on an empty geometry.
    hl.exec_cmd("mkdir -p " .. DIR .. ' && g=$(slurp) && grim -g "$g" ' .. FILE)
  end
end

---Capture the currently focused window from its Hyprland geometry.
---@return function
function M.window()
  return function()
    local win = hl.get_active_window()
    if not win then
      return
    end

    -- at = {x, y}, size = {w, h}; accept either array or x/y-keyed tables.
    local at, size = win.at, win.size
    local x, y = at.x or at[1], at.y or at[2]
    local w, h = size.x or size[1], size.y or size[2]
    if not (x and y and w and h) then
      return
    end

    capture(string.format("-g '%d,%d %dx%d'", x, y, w, h))
  end
end

---Capture every monitor stitched into one image.
---@return function
function M.screen()
  return function()
    capture("")
  end
end

return M

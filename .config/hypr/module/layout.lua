local M = {}

-- Layouts that next/prev cycle through, in order. Override with M.setup({...}).
local cycle = { "dwindle", "master", "scrolling", "monocle" }

---Configure which layouts `next`/`prev` cycle through, in order.
---If never called, the default cycle is dwindle -> master -> scrolling -> monocle.
---@param layouts string[]
function M.setup(layouts)
  assert(type(layouts) == "table" and #layouts > 0, "layout.setup: expected a non-empty list of layout names")
  cycle = layouts
end

---Name of the tiled layout on the focused workspace, falling back to the
---configured general.layout.
---@return string
local function current()
  local ws = hl.get_active_workspace()
  local name = ws and ws.tiled_layout
  if not name or name == "unknown" then
    name = hl.get_config("general.layout")
  end
  return name
end

---Switch the active layout by stepping `step` positions through the cycle list.
---@param step integer
local function step_to(step)
  local now = current()

  local index
  for i, name in ipairs(cycle) do
    if name == now then
      index = i
      break
    end
  end

  -- If the current layout isn't in the cycle, next starts at the first entry and
  -- prev starts at the last.
  if not index then
    index = step >= 0 and 0 or #cycle + 1
  end

  local target = (index - 1 + step) % #cycle + 1
  hl.config({ general = { layout = cycle[target] } })
end

---Cycle to the next layout in the configured list.
---@return function dispatcher
function M.next()
  return function()
    step_to(1)
  end
end

---Cycle to the previous layout in the configured list.
---@return function dispatcher
function M.prev()
  return function()
    step_to(-1)
  end
end

---Dispatch the handler whose key matches the current layout, or `default` if
---none match. Handler values may be dispatchers (`hl.dsp.*`) or plain functions.
---
---  module.layout.match({
---    dwindle = hl.dsp.window.swap({ direction = "left" }),
---    scrolling = hl.dsp.layout("swapcol l"),
---    default = hl.dsp.window.swap({ direction = "left" }),
---  })
---
---@param handlers table<string, HL.Dispatcher|function>
---@return function dispatcher
function M.match(handlers)
  return function()
    local handler = handlers[current()] or handlers.default
    if handler then
      hl.dispatch(handler)
    end
  end
end

return M

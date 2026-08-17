local M = {}

---Resolve an axis value to logical pixels, returning nil on invalid input.
---  number             -> absolute pixels (no range limit)
---  "5%" / "-10%"      -> percentage of `extent`, restricted to -100%..100%
---  "120"              -> absolute pixels
---  anything malformed -> nil (caller should no-op)
---@param value number|string
---@param extent number logical size of the axis, in pixels
---@return number|nil
local function to_pixels(value, extent)
  if type(value) == "number" then
    return value
  end

  if type(value) == "string" then
    local num = value:match("^(-?%d*%.?%d+)%%$")
    if num then
      local pct = tonumber(num)
      if pct >= -100 and pct <= 100 then
        return pct / 100 * extent
      end
      return nil -- percentage out of range
    end
    return tonumber(value) -- plain absolute pixels, or nil if malformed
  end

  return nil
end

---Like `hl.dsp.window.resize`, but `x`/`y` also accept percentage strings
---("5%", "-10%") resolved against the active monitor's logical size at the moment
---the bind fires. Invalid or out-of-range values are ignored (no resize happens).
---
---  module.window.resize({ x = "5%", y = 0, relative = true })
---  module.window.resize({ x = "50%", y = "50%" })  -- exact size, half the monitor
---
---@param opts { x: number|string, y: number|string, relative?: boolean, window?: HL.WindowSelector }
---@return function dispatcher
function M.resize(opts)
  return function()
    local monitor = hl.get_active_monitor()
    if not monitor then
      return
    end

    -- monitor.width/height are physical pixels; resize works in logical pixels.
    local scale = monitor.scale
    local x = to_pixels(opts.x, monitor.width / scale)
    local y = to_pixels(opts.y, monitor.height / scale)
    if x == nil or y == nil then
      return
    end

    hl.dispatch(hl.dsp.window.resize({
      x = x,
      y = y,
      relative = opts.relative,
      window = opts.window,
    }))
  end
end

return M

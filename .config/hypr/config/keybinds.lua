local module = require("module")

---------------------
---- KEYBINDINGS ----
---------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"

---- Workspace Management

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:scratchpad" }))

for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

---- Window Management

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + C", hl.dsp.window.center())
hl.bind(mainMod .. " + T", hl.dsp.window.float())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
  mainMod .. " + equal",
  module.layout.match({
    default = module.window.resize({ x = "5%", y = 0, relative = true }),
    scrolling = hl.dsp.layout("colresize +conf"),
  }),
  { repeating = true }
)
hl.bind(
  mainMod .. " + minus",
  module.layout.match({
    default = module.window.resize({ x = "-5%", y = 0, relative = true }),
    scrolling = hl.dsp.layout("colresize -conf"),
  }),
  { repeating = true }
)
hl.bind(mainMod .. " + SHIFT + equal", module.window.resize({ x = 0, y = "5%", relative = true }), { repeating = true })
hl.bind(
  mainMod .. " + SHIFT + minus",
  module.window.resize({ x = 0, y = "-5%", relative = true }),
  { repeating = true }
)

local hjkl_binds = {
  { key = "H", direction = "left" },
  { key = "J", direction = "down" },
  { key = "K", direction = "up" },
  { key = "L", direction = "right" },
}

for _, bind in ipairs(hjkl_binds) do
  hl.bind(mainMod .. " + " .. bind.key, hl.dsp.focus({ direction = bind.direction }))
  hl.bind(mainMod .. " + SHIFT + " .. bind.key, hl.dsp.window.move({ direction = bind.direction }))
  hl.bind(
    mainMod .. " + CTRL + " .. bind.key,
    module.layout.match({
      dwindle = hl.dsp.window.swap({ direction = bind.direction }),
      scrolling = function()
        local fn

        if bind.direction == "left" or bind.direction == "right" then
          fn = hl.dsp.layout("swapcol " .. (bind.direction == "left" and "l" or "r"))
        else
          fn = hl.dsp.window.swap({ direction = bind.direction })
        end

        hl.dispatch(fn)
      end,
    })
  )
end

---- Group Management

hl.bind(mainMod .. " + W", hl.dsp.group.toggle())
hl.bind(mainMod .. " + BracketLeft", hl.dsp.group.prev())
hl.bind(mainMod .. " + BracketRight", hl.dsp.group.next())

---- Layout Management

hl.bind(mainMod .. " + R", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Backslash", module.layout.next())
hl.bind(mainMod .. " + SHIFT + Backslash", module.layout.prev())

---- Screen Capture

hl.bind(mainMod .. " + P", module.screenshot.region())
hl.bind(mainMod .. " + SHIFT + P", module.screenshot.window())
hl.bind(mainMod .. " + CTRL + P", module.screenshot.screen())

---- Execution Binds

local exec_binds = {
  { key = "RETURN", exec = "uwsm app -- kitty" },
  { key = "SHIFT + RETURN", exec = "uwsm app -- emacs" },
  { key = "B", exec = "uwsm app -- zen-browser" },

  --- Temporary binds. Because currently I don't have any application launcher set up.
  { key = "G", exec = "uwsm app -- twintaillauncher" },
  { key = "SHIFT + G", exec = "uwsm app -- steam" },

  { key = "O", exec = "uwsm app -- obs" },
  { key = "SHIFT + O", exec = "uwsm app -- kdenlive" },

  { key = "M", exec = "uwsm stop" },
}

for _, bind in ipairs(exec_binds) do
  local key = bind.key
  if bind.with_mod ~= false then
    key = mainMod .. " + " .. key
  end

  hl.bind(key, hl.dsp.exec_cmd(bind.exec), bind.opts)
end

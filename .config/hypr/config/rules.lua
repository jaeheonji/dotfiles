--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
  match = {
    group = true,
  },

  border_size = 2,
})

hl.window_rule({
  match = {
    class = "oh-my-opencode-slim-companion",
    title = "oh-my-opencode-slim-companion",
  },

  float = true,
  no_initial_focus = true,
  size = { 160, 160 },
  move = { "monitor_w- window_w-64", "monitor_h-window_h-64" },
})

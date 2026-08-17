require("module.layout").setup({ "dwindle", "scrolling" })

hl.config({
  general = {
    layout = "dwindle",
  },
})

-----------------
---- DWINDLE ----
-----------------
-- Refer to https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/

hl.config({
  dwindle = {
    preserve_split = true,
  },
})

-------------------
---- SCROLLING ----
-------------------
-- Refer to https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/

hl.config({
  scrolling = {
    fullscreen_on_one_column = false,
  },
})

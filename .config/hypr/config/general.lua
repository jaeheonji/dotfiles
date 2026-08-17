local catppuccin = require("colors.catppuccin-mocha")

-----------------------
---- LOOK AND FEEL ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/

hl.config({
  general = {
    border_size = 0,
    gaps_in = 0,
    gaps_out = 0,

    snap = {
      enabled = true,
    },
  },
})

hl.config({
  decoration = {
    rounding = 0,

    shadow = { enabled = false },
    blur = {
      enabled = true,
    },
  },
})

hl.config({
  group = {
    col = { border_active = catppuccin.green, border_inactive = catppuccin.green },
    groupbar = {
      font_family = "Maple Mono NF",
      font_size = 14,
      font_weight_active = "bold",

      height = 18,
      indicator_height = 0,

      gaps_in = 8,
      gaps_out = 8,

      gradients = true,
      col = { active = "rgba(00000000)", inactive = "rgba(00000000)" },

      text_color = catppuccin.green,
      text_color_inactive = catppuccin.text,
    },
  },
})

-----------------------
---- MISCELLANEOUS ----
-----------------------
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/#misc

hl.config({
  misc = {
    disable_hyprland_logo = true,
    background_color = "rgb(000000)",
  },
})

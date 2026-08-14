return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      float = { transparent = true },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = "",
        section_separators = " ",
      },
    },
  },

  -- Override default opts for render-markdown.nvim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      code = { sign = true },
      checkbox = {
        enabled = true,
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
          progress = { raw = "[~]", rendered = " ", highlight = "RenderMarkdownHint" },
          warn = { raw = "[!]", rendered = " ", highlight = "RenderMarkdownWarn" },
          ref = { raw = "[>]", rendered = "󰒊 ", highlight = "RenderMarkdownTableRow" },
        },
      },
      heading = {
        sign = true,
        icons = { "󰼏 ", "󰎨 ", "󰼑 ", "󰎲 ", "󰼓 ", "󰎴 " },
        position = "inline",
      },
    },
  },
}

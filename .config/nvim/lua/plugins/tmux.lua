return {
  -- tmux
  {
    "christoomey/vim-tmux-navigator",
    cond = vim.env.TERM_PROGRAM == "tmux",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- herdr
  {
    "lmilojevicc/herdr-splits.nvim",
    -- For local development, swap the repo line for `dir = '/path/to/herdr-splits'`
    -- (see "Local development" below).
    cond = vim.env.HERDR_ENV == "1",
    event = "VeryLazy",
    -- Optional: auto-sync the Herdr-side scripts when lazy updates this plugin.
    -- Requires `auto_sync_herdr = true` in setup() below to take effect.
    -- build = ':lua require("herdr-splits").sync_herdr()',
    config = function()
      require("herdr-splits").setup({
        -- Defaults shown. All fields optional.
        default_amount = 0.03, -- Herdr resize ratio
        neovim_amount = 3, -- Neovim resize cells
        at_edge = "wrap", -- 'wrap' | 'stop' | 'split' | function
        ignored_buftypes = { "nofile", "quickfix", "prompt", "help", "terminal" },
        ignored_filetypes = {
          "NvimTree",
          -- sidebars
          "neo-tree",
          "snacks_dashboard",
          "snacks_explorer",
          "snacks_picker",
          -- DB / REPL / data sidebars
          "dadbod-ui",
          "dbout",
          -- outlines / symbols
          "aerial",
          "Outline",
          -- diagnostics / quick lists
          "Trouble",
          "quickfix",
        },
        move_cursor_same_row = false,
        herdr_bin = nil, -- auto-detected from HERDR_BIN_PATH
        floating_zindex_max = 50, -- floats with zindex < this are treated as embedded sidebars
        ignore_previewwindows = false, -- opt-in: also treat previewwindow windows (e.g. .dbout) as sidebars
        -- auto_sync_herdr = true,      -- opt-in: sync Herdr-side scripts on update
        -- Managed keys — written to the generated herdr-splits.conf so the
        -- Herdr-side scripts agree. Pass Neovim notation (e.g. <M-Left>).
        nav_keys = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
        resize_keys = { left = "<M-h>", down = "<M-j>", up = "<M-k>", right = "<M-l>" },
        unzoom_on_nav = true, -- auto-unzoom when navigating away from a zoomed pane
        nav_at_edge = "wrap", -- 'wrap' | 'stop' — Herdr pane-boundary wrap (distinct from at_edge)
      })
    end,
    keys = {
      {
        "<C-h>",
        function()
          require("herdr-splits").move_cursor_left()
        end,
        desc = "Navigate left",
      },
      {
        "<C-j>",
        function()
          require("herdr-splits").move_cursor_down()
        end,
        desc = "Navigate down",
      },
      {
        "<C-k>",
        function()
          require("herdr-splits").move_cursor_up()
        end,
        desc = "Navigate up",
      },
      {
        "<C-l>",
        function()
          require("herdr-splits").move_cursor_right()
        end,
        desc = "Navigate right",
      },
      {
        "<M-h>",
        function()
          require("herdr-splits").resize_left()
        end,
        desc = "Resize left",
      },
      {
        "<M-j>",
        function()
          require("herdr-splits").resize_down()
        end,
        desc = "Resize down",
      },
      {
        "<M-k>",
        function()
          require("herdr-splits").resize_up()
        end,
        desc = "Resize up",
      },
      {
        "<M-l>",
        function()
          require("herdr-splits").resize_right()
        end,
        desc = "Resize right",
      },
    },
  },
}

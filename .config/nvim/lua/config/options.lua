-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use dms clipboard integration
vim.g.clipboard = {
  name = "dms-clipboard",
  copy = {
    ["+"] = "dms cl copy",
    ["*"] = "dms cl copy",
  },
  paste = {
    ["+"] = "dms cl paste",
    ["*"] = "dms cl paste",
  },
  cache_enabled = false,
}

-- Native inline completions don't support being shown as regular completions
vim.g.ai_cmp = false

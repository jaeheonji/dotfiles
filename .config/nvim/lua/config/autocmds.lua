-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable inlay hints in Insert mode, re-enable in Normal mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = vim.api.nvim_create_augroup("inlay_hints_insert", { clear = true }),
  callback = function(args)
    vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = vim.api.nvim_create_augroup("inlay_hints_normal", { clear = true }),
  callback = function(args)
    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
  end,
})

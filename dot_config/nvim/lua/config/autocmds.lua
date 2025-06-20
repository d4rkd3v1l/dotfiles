-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false

    -- enable autoformat
    vim.b.autoformat = true

    -- disable indentaton guides
    vim.b.snacks_indent = false
  end,
})

-- custom highlight groups
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = {  "dracula" },
  callback = function()
    vim.api.nvim_set_hl(0, "@markup.list.checked.markdown", { link = "Conceal" })
  end
})

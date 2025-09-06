-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Shared clipboard with system
vim.opt.clipboard = "unnamedplus"

-- Default: "\", but sux on german keyboard^^
vim.g.maplocalleader = "#"

-- Don't autoformat on save
vim.g.autoformat = false

-- Tabs and indents
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Cursor Line
vim.opt.cursorline = true

-- Cursor Update Time
vim.opt.updatetime = 150

-- Width Indicator
-- NOTE: Managed by virt-column.nvim plugin.
vim.opt.colorcolumn = ""

-- Line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true

-- Better scrolling visibility
vim.opt.scrolloff = 8

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- Windows preferences
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Listchars
vim.opt.list = true
vim.opt.listchars = {
  tab = "»»",
  trail = "⋅",
  nbsp = "·",
  extends = "›",
  precedes = "‹",
}

-- NOTE: Fix for bullets.vim issue (https://github.com/folke/snacks.nvim/issues/812)
vim.g.bullets_enable_in_empty_buffers = 0


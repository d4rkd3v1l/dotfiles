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

-- Wrap and check for spelling in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = false
    vim.opt_local.linebreak = false
    vim.opt_local.spell = false

    -- Enable autoformat
    vim.b.autoformat = true

    -- Disable indentaton guides
    vim.b.snacks_indent = false
  end,
})

-- Markdown: Disable some LSP features that interfere with Tree-sitter highlighting
-- (in order to make e.g. checked checkboxes "- [x]" highlights work properly)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client.name == "marksman" then
      client.server_capabilities.semanticTokensProvider = nil
      client.server_capabilities.codeLensProvider = nil
      client.server_capabilities.foldingRangeProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.colorProvider = nil
    end
  end,
})

-- Open Trouble symbols for markdown
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local filetype = vim.bo.filetype
    if filetype == "markdown" or filetype == "trouble" then
      vim.cmd("Trouble symbols open focus=false")
    else
      vim.cmd("Trouble symbols close")
    end
  end,
})

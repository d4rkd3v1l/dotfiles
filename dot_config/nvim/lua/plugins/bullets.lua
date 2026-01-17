return {
  "bullets-vim/bullets.vim",
  ft = { "markdown" },
  config = function()
    -- "Disable" partially checked states
    vim.g.bullets_checkbox_markers = '    x'

    vim.g.bullets_nested_checkboxes = 0
  end,
}

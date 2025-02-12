return {
  "bullets-vim/bullets.vim",
  ft = { "markdown" },
  config = function()
    vim.keymap.set("n", "<leader>mc", "<Cmd>ToggleCheckbox<CR>", { desc = "Toggle checkbox" })

    -- "Disable" partially checked states
    vim.g.bullets_checkbox_markers = '    x'

    vim.g.bullets_nested_checkboxes = 0
  end,
}

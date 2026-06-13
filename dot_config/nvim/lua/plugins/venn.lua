return {
  'jbyuki/venn.nvim',
  ft = { "markdown", "text" },
  keys = {
    {
      "<leader>v",
      function ()
        local venn_enabled = vim.inspect(vim.b.venn_enabled)
        if venn_enabled == "nil" then
          vim.b.venn_enabled = true
          vim.cmd([[setlocal ve=all]]) -- Enable "Virtual Edit" (cursor everywhere)

          -- Draw lines with HJKL (Shift + h/j/k/l)
          vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })

          -- Draw Box with 'f' in Visual Mode
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })

          vim.notify("Venn Drawing: ON", vim.log.levels.INFO)
        else
          vim.cmd([[setlocal ve=]]) -- Reset Virtual Edit
          vim.b.venn_enabled = nil

          -- Remove the keymaps when turning off
          vim.api.nvim_buf_del_keymap(0, "n", "J")
          vim.api.nvim_buf_del_keymap(0, "n", "K")
          vim.api.nvim_buf_del_keymap(0, "n", "L")
          vim.api.nvim_buf_del_keymap(0, "n", "H")
          vim.api.nvim_buf_del_keymap(0, "v", "f")

          vim.notify("Venn Drawing: OFF", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle Venn (Drawing Mode)" },
  },
}

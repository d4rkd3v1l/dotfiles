-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ESC mappings
vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")
vim.keymap.set("i", "<C-c>", "<ESC>")

-- Make x and c go into the black hole (don’t overwrite clipboard)
vim.keymap.set({ "n", "x" }, "x", '"_x')
vim.keymap.set({ "n", "x" }, "c", '"_c')
vim.keymap.set({ "n", "x" }, "C", '"_C')

-- Buffers
vim.keymap.set("n", "<leader><BS>", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })

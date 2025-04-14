return {
  {
    "LazyVim/LazyVim",
    priority = 1000, -- make sure it runs after colorscheme is set
    init = function()
      vim.api.nvim_set_hl(0, "@markup.list.checked.markdown", { link = "Conceal" })
    end,
  },
}

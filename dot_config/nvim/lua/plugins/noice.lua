return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        bottom_search = false,
      },
      messages = {
        enabled = true,
        view = "mini",
        view_error = "mini",
        view_warn = "mini",
        view_history = "mini",
        view_search = "mini",
      },
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        message = {
          enabled = true,
          view = "mini",
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = "10",
            col = "50%",
          },
        },
        mini = {
          timeout = 5000,
          align = "right",
          position = {
            row = "95%",
            col = "100%",
          },
        },
      },
    }
  }
}

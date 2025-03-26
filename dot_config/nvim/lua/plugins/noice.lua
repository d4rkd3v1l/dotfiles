return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        bottom_search = false,
      },
      views = {
        cmdline_popup = {
          position = {
            row = "10",
            col = "50%",
          },
        },
      },
      routes = {
        {
          view = "notify",
          filter = { event = "msg_showmode" },
        },
      },
    }
  }
}

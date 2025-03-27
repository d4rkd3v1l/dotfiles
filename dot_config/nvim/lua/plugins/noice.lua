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
            row = 8,
            col = "50%",
          },
        },
        cmdline_popupmenu = {
          relative = "editor",
          position = {
            row = 11,
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

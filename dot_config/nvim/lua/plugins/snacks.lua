return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.styles = vim.tbl_deep_extend("force", opts.styles or {}, {
      snacks_image = {
        relative = "editor",
        col = -1,
      },
      scratch = {
        width = 0.75,
        height = 0.75,
        zindex = 20,
      },
    })

    opts.image = vim.tbl_deep_extend("force", opts.image or {}, {
      enabled = true,
      doc = {
        inline = false,
        float = true,
        max_width = 80,
        max_height = 40,
      },
    })

    opts.dashboard = vim.tbl_deep_extend("force", opts.dashboard or {}, {
      enabled = true,

      preset = {
        header = [[
██████╗ ██╗  ██╗██████╗ ██╗  ██╗██╗   ██╗██╗███╗   ███╗
██╔══██╗██║  ██║██╔══██╗██║ ██╔╝██║   ██║██║████╗ ████║
██║  ██║███████║██████╔╝█████╔╝ ██║   ██║██║██╔████╔██║
██║  ██║╚════██║██╔══██╗██╔═██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
██████╔╝     ██║██║  ██║██║  ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═════╝      ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]]
      },
    })

    return opts
  end,
}

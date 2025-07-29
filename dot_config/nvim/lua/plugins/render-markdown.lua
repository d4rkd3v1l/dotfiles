return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    win_options = {
      conceallevel = {
        default = 0, --vim.api.nvim_get_option_value('conceallevel', {}),
        rendered = 3,
      },
      concealcursor = {
        default = '', --vim.api.nvim_get_option_value('concealcursor', {}),
        rendered = '',
      },
    },
    bullet = {
      enabled = true,
    },
    code = {
      enabled = true,
      sign = false,
      language_pad = 1,
      width = "block",
      right_pad = 1,
      border = "none",
      inline_pad = 1,
    },
    heading = {
      enabled = true,
      sign = false,
      render_modes = false,
      -- icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      -- icons = { "󰬺", "󰬻", "󰬼", "󰬽", "󰬾", "󰬿" },
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      -- icons = { "󰎦 ", "󰎩 ", "󰎬 ", "󰎮 ", "󰎰 ", "󰎵 " },
      -- icons = { "󰲠 ", "󰲢 ", "󰲤 ", "󰲦 ", "󰲨 ", "󰲪 " },
      -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      -- icons = { "󰼏 ", "󰼐 ", "󰼑 ", "󰼒 ", "󰼓 ", "󰼔 " },
      -- icons = { "󰎥 ", "󰎨 ", "󰎫 ", "󰎲 ", "󰎯 ", "󰎴 " },
      width = "block",
      right_pad = 1,
    },
    checkbox = {
      enabled = true,
      position = "inline",
      unchecked = {
        icon = "   󰄱 ",
        highlight = "RenderMarkdownUnchecked",
        scope_highlight = nil,
      },
      checked = {
        icon = "   󰄲 ",
        highlight = "Conceal",
        scope_highlight = "Conceal",
      },
      custom = {
        todo = {
          raw = "[-]",
          rendered = "   󰥔 ",
          highlight = "RenderMarkdownTodo",
          scope_highlight = nil
        },
      },
    },
    pipe_table = {
      style = "normal",
    },
  }
}

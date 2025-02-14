return {
  { "Mofiqul/dracula.nvim",
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        overrides = {
          ["@markup.heading.1.markdown"] = { fg = dracula.colors().fg, bold = true },
          ["@markup.heading.2.markdown"] = { fg = dracula.colors().pink, bold = true },
          ["@markup.heading.3.markdown"] = { fg = dracula.colors().cyan, bold = true },
          ["@markup.heading.4.markdown"] = { fg = dracula.colors().green, bold = true },
          ["@markup.heading.5.markdown"] = { fg = dracula.colors().purple, bold = true },
          ["@markup.heading.6.markdown"] = { fg = dracula.colors().orange, bold = true },
          ["RenderMarkdownH1Bg"] = { fg = dracula.colors().bg, bg = dracula.colors().fg },
          ["RenderMarkdownH2Bg"] = { fg = dracula.colors().bg, bg = dracula.colors().pink },
          ["RenderMarkdownH3Bg"] = { fg = dracula.colors().bg, bg = dracula.colors().cyan },
          ["RenderMarkdownH4Bg"] = { fg = dracula.colors().bg, bg = dracula.colors().green },
          ["RenderMarkdownH5Bg"] = { fg = dracula.colors().bg, bg = dracula.colors().purple },
          ["RenderMarkdownH6Bg"] = { fg = dracula.colors().bg, bg = dracula.colors().orange },
          ["@markup.italic"] = { fg = dracula.colors().yellow, italic = true },
          ["@markup.strikethrough"] = { fg = dracula.colors().comment, strikethrough = true },
        },
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
}

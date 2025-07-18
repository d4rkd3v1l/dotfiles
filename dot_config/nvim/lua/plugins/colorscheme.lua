return {
  {
    "d4rkd3v1l/dracula.nvim",
    branch = "render-markdown",
    -- config = function()
      -- local dracula = require("dracula")
      -- dracula.setup({
      --   overrides = {
      --     ["@markup.heading.1.markdown"] = { fg = dracula.colors().fg, bold = true },
      --     ["@markup.heading.2.markdown"] = { fg = dracula.colors().pink, bold = true },
      --     ["@markup.heading.3.markdown"] = { fg = dracula.colors().cyan, bold = true },
      --     ["@markup.heading.4.markdown"] = { fg = dracula.colors().green, bold = true },
      --     ["@markup.heading.5.markdown"] = { fg = dracula.colors().purple, bold = true },
      --     ["@markup.heading.6.markdown"] = { fg = dracula.colors().orange, bold = true },
      --     ["RenderMarkdownH1Bg"] = { fg = dracula.colors().fg, bg = "#6A6A66" },
      --     ["RenderMarkdownH2Bg"] = { fg = dracula.colors().pink, bg = "#6E4B5F" },
      --     ["RenderMarkdownH3Bg"] = { fg = dracula.colors().cyan, bg = "#3B6068" },
      --     ["RenderMarkdownH4Bg"] = { fg = dracula.colors().green, bg = "#41644A" },
      --     ["RenderMarkdownH5Bg"] = { fg = dracula.colors().purple, bg = "#524664" },
      --     ["RenderMarkdownH6Bg"] = { fg = dracula.colors().orange, bg = "#5F4C36" },
      --     ["@markup.italic"] = { fg = dracula.colors().yellow, italic = true },
      --     ["@markup.strikethrough"] = { fg = dracula.colors().comment, strikethrough = true },
      --   },
      -- })
    -- end,
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

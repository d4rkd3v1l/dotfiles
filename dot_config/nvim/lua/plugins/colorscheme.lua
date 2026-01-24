return {
  {
    "Mofiqul/dracula.nvim",
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        overrides = {
          Special = { fg = dracula.colors().green },
          SpecialComment = { fg = dracula.colors().comment },

          -- TreeSitter
          ['@markup.list'] = { fg = dracula.colors().fg, },
          ['@markup.list.checked'] = { link = "Conceal" },
          ['@markup'] = { fg = dracula.colors().green, },
          ['@markup.italic'] = { link = "@markup.emphasis" },
          ['@markup.underline'] = { fg = dracula.colors().purple, },
          ['@markup.strikethrough'] = { fg = dracula.colors().comment, strikethrough = true },
          ['@markup.raw'] = { fg = dracula.colors().purple, },
          ['@markup.link.url'] = { fg = dracula.colors().purple, },
          ['@markup.link'] = { fg = dracula.colors().cyan, bold = true, },

          -- Markdown
          markdownCodeBlock = { fg = dracula.colors().orange, bg = dracula.colors().menu },
          markdownH1 = { link = "rainbowcol1" },
          markdownH2 = { link = "rainbowcol2" },
          markdownH3 = { link = "rainbowcol3" },
          markdownH4 = { link = "rainbowcol4" },
          markdownH5 = { link = "rainbowcol5" },
          markdownH6 = { link = "rainbowcol6" },
          ['@markup.quote.markdown'] = { fg = dracula.colors().green },
          ['@punctuation.special.markdown'] = { fg = dracula.colors().fg },
          ['@markup.heading.1.markdown'] = { fg = dracula.colors().fg, bold = true },
          ['@markup.heading.2.markdown'] = { fg = dracula.colors().green, bold = true },
          ['@markup.heading.3.markdown'] = { fg = dracula.colors().cyan, bold = true },
          ['@markup.heading.4.markdown'] = { fg = dracula.colors().pink, bold = true },
          ['@markup.heading.5.markdown'] = { fg = dracula.colors().purple, bold = true },
          ['@markup.heading.6.markdown'] = { fg = dracula.colors().orange, bold = true },

          -- Render-Markdown
          ['RenderMarkdownH1Bg'] = { fg = dracula.colors().bg, bg = dracula.colors().fg },
          ['RenderMarkdownH2Bg'] = { fg = dracula.colors().bg, bg = dracula.colors().green },
          ['RenderMarkdownH3Bg'] = { fg = dracula.colors().bg, bg = dracula.colors().cyan },
          ['RenderMarkdownH4Bg'] = { fg = dracula.colors().bg, bg = dracula.colors().pink },
          ['RenderMarkdownH5Bg'] = { fg = dracula.colors().bg, bg = dracula.colors().purple },
          ['RenderMarkdownH6Bg'] = { fg = dracula.colors().bg, bg = dracula.colors().orange },
          RenderMarkdownCode = { bg = dracula.colors().menu },

          -- Bufferline
          BufferLineFill = { bg = dracula.colors().bg, },
          BufferLineBufferSelected = { bg = dracula.colors().bg, bold = true, },
          BufferLineSeparator = { fg = dracula.colors().bg },

          -- d4Rk specific Treesitter queries
          ['@d4rk.markdown.task_checked_marker_minus'] = { fg = dracula.colors().comment },
          ['@d4rk.markdown.task_checked_marker'] = { fg = dracula.colors().comment },
          ['@d4rk.markdown.task_checked_text'] = { fg = dracula.colors().comment },
          ['@d4rk.markdown.horizontal_rule'] = { fg = dracula.colors().comment },
          ['@d4Rk.markdown.block_quote_marker'] = { fg = dracula.colors().green },
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

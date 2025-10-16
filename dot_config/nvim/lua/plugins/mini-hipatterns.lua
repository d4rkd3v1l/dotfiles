require('mini.hipatterns').setup({
  highlighters = {
    -- Default hex color highlighting (#rrggbb)
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),

    -- Custom ARGB color highlighting (0xff50fa7b)
    argb_color = {
      pattern = '[0][xX]%x%x%x%x%x%x%x%x',
      group = function(_, match)
        -- Extract RRGGBB (last 6 hex digits)
        local rgb = match:sub(-6)
        -- Return a highlight group dynamically created for that color
        return require('mini.hipatterns').compute_hex_color_group('#' .. rgb, 'bg')
      end,
    },
  },
})

return {
  {
    "SCJangra/table-nvim",
    ft = "markdown",
    opts = {},
    keys = {
      { "<leader>to", function() require('table-nvim.edit').insert_row_down() end, desc = "Insert row down" },
      { "<leader>tO", function() require('table-nvim.edit').insert_row_up() end, desc = "Insert row up" },
      { "<leader>tj", function() require('table-nvim.edit').move_row_down() end, desc = "Move row down" },
      { "<leader>tk", function() require('table-nvim.edit').move_row_up() end, desc = "Move row up" },
      { "<leader>ti", function() require('table-nvim.edit').insert_column_left() end, desc = "Insert column left" },
      { "<leader>ta", function() require('table-nvim.edit').insert_column_right() end, desc = "Insert column right" },
      { "<leader>th", function() require('table-nvim.edit').move_column_left() end, desc = "Move column left" },
      { "<leader>tl", function() require('table-nvim.edit').move_column_right() end, desc = "Move column right" },
      { "<leader>tx", function() require('table-nvim.edit').insert_table() end, desc = "Insert table" },
      { "<leader>td", function() require('table-nvim.edit').delete_current_column() end, desc = "Delete column" },
    },
  }
}

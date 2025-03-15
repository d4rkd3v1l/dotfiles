return {
  "folke/snacks.nvim",
  opts = {
    styles = {
      snacks_image = {
        -- Display image in the top right
        relative = "editor",
        col = -1,
      },
    },
    image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
        max_width = 80,
        max_height = 40,
      }
    }
  }
}


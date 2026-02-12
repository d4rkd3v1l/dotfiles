return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- Unified keymaps
    local keymap = {
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
      ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
    }

    -- Insert mode
    opts.keymap = keymap
    opts.keymap.preset = "enter"

    -- Command mode
    opts.cmdline = opts.cmdline or {}
    opts.cmdline.enabled = true
    opts.cmdline.keymap = keymap

    return opts
  end,
}

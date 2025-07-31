return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
      ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
    },
  }
}

return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        prepend_args = {
          "--config",
          vim.fn.expand("~/.config/nvim/.markdownlint.yaml"),
        },
      },
    },
  },
}

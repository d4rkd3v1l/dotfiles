return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        prepend_args = { "--config", os.getenv("HOME") .. "/.config/nvim/.markdownlint.yaml", "--" },
      },
    },
  },
}

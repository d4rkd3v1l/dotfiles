-- Check which linter is currently used for a buffer use:
-- :lua print(vim.inspect(require('lint').linters_by_ft[vim.bo.filetype]))

return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      markdownlint = {
        args = { "--config", os.getenv("HOME") .. "/.config/nvim/.markdownlint.yaml", "--" },
      },
    },
  },
}

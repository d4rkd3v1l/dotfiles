return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = {},
      sourcekit = {
        cmd = { "xcrun", "sourcekit-lsp" },
      },
    },
  },
}

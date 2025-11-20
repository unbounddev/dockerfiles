return {
  "neovim/nvim-lspconfig",
  config = function()
    require("nvchad.configs.lspconfig").defaults()

    local servers = {
      "lua_ls", "ts_ls", "cssls",
      "css_variables", "html",
      "lemminx", "pylsp"
    }
    vim.lsp.enable(servers)
  end,
}

require("nvchad.configs.lspconfig").defaults()

local servers = {
  "lua_ls", "ts_ls", "cssls",
  "css_variables", "html",
  "lemminx", "pylsp"
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
